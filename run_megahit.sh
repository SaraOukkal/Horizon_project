#!/bin/bash

set -eEuo pipefail
IFS=$'\n\t'


readonly EXE="$(basename $0)"

Usage() {
  cat <<END_DOC
Usage:
  $EXE [OPTIONS]

Description:
  Assemble contigs using megahit.

Options:
  -s, --sample:      sample name
  -1, --fwd:         forward reads (comma separated)
  -2, --rev:         reverse reads (comma separated)

  -c, --cpus:        number of parallel threads for mapping
  -m, --memory       Memory usage in bytes!


  -h, --help:     Display this help message

Author:
    Samuel Barreto, 2020-11-25

END_DOC

  exit 0
}

# args ---------------------------------------------------------------
# no args:
if [ $# -eq 0 ]; then > /dev/null && Usage; fi

# args ---------------------------------------------------------------
while [ "$#" -gt 0 ]; do
  case "$1" in
    -h) Usage ;;
    --help) Usage ;;
    #
    -s) arg_sample="$2"; shift 2 ;;
    --sample=*) arg_sample="${1#*=}"; shift 1;;
    #
    -1) arg_fwd="$2"; shift 2 ;;
    --fwd=*) arg_fwd="${1#*=}"; shift 1;;
    #
    -2) arg_rev="$2"; shift 2 ;;
    --rev=*) arg_rev="${1#*=}"; shift 1;;
    #
    -m) arg_memory="$2"; shift 2 ;;
    --memory=*) arg_memory="${1#*=}"; shift 1;;
    #
    -c) arg_cpus="$2"; shift 2 ;;
    --cpus=*) arg_cpus="${1#*=}"; shift 1;;
    #
    -*) echo "unknown option: $1" >&2; exit 1;;
    --) shift 1 && break ;;
  esac
done

radix="${arg_sample}"
memory="${arg_memory}"
ncpus="${arg_cpus}"


log_dir="/beegfs/data/soukkal/Thesis/Horizon/Assembly/logs/${radix}/.log"
readonly LOG_FILE="${log_dir}/${EXE}.log"

_date() { date +%Y-%m-%d-%H%M%S ;}
__msg() {
    local name="$1" && shift;
    echo -e "# [${radix}] [${EXE}] ($(_date)) ${name}:  $@" | tee -a "$LOG_FILE" >&2 ;
}

_info()    { __msg "INFO"  $@ ; }
_prompt()  { __msg "PROMPT" $@ ; }
_warn()    { __msg "WARN"  $@ ; }
_error()   { __msg "ERROR" $@ ; }
_fatal()   { __msg "FATAL" $@ && exit 1 ; }

__currently_doing=""
_doing () { __currently_doing="$1"; _info "${__currently_doing} ..." ; }
_done ()  { _info "${__currently_doing}: done." ; }


function yes_or_no {
  while true; do
    read -p "$* [y/n]: " yn
    case $yn in
      [Yy]*) return 0  ;;
      [Nn]*) return 1 ;;
    esac
  done
}

function Continue {
  _prompt "Continue job [yN]?"
  yes_or_no "Continue job?"
}

# defaults -----------------------------------------------------------
if [ -d "/beegfs/data/soukkal/Thesis/Horizon/Assembly/" ]; then
  tmp_dir="/beegfs/data/soukkal/Thesis/Horizon/Assembly/${radix}"
else
  tmp_dir="/beegfs/data/soukkal/Thesis/Horizon/Assembly/${radix}"
  _warn "Writing on /tmp; hostname is $(hostname)"
fi
tmp_work_dir="${tmp_dir}/tmp"
work_dir="${tmp_dir}/assembly"
out_dir="${tmp_dir}/Assembly"
fwd_reads=$(sed "s|${tmp_dir}/|${tmp_work_dir}/|g" <<< "${arg_fwd}")
rev_reads=$(sed "s|${tmp_dir}/|${tmp_work_dir}/|g" <<< "${arg_rev}")
# assembly_img="${singularity_dir}/assembly-3.sif"

# run ----------------------------------------------------------------
Main() {
  _info "RUNNING MEGAHIT."
  _info "Forward reads are in [${arg_fwd}]; copied to [${fwd_reads}]"
  _info "Reverse reads are in [${arg_rev}]; copied to [${rev_reads}]"
  _info "megahit output goes to [${work_dir}]"
  _info "megahit temporary output goes to [${tmp_work_dir}]"
  _info "assembly output goes to [${out_dir}]"
  _info "log files are in [${log_dir}]"
  # _info "Using singularity image [${assembly_img}]"
  #
  mkdir -p ${tmp_work_dir}
  _doing "Copying input reads to work dir"
  echo "cp --update ${arg_rev//,/ } ${tmp_work_dir}/" | bash
  echo "cp --update ${arg_fwd//,/ } ${tmp_work_dir}/" | bash
  _done
  #
  _doing "Megahit assembly"
  # singularity \
  #   --silent exec --bind ${tmp_dir}:${tmp_dir} ${assembly_img}
  megahit \
	-1 ${fwd_reads} \
    -2 ${rev_reads} \
    --out-dir ${work_dir} \
    --out-prefix "assembly" \
    --num-cpu-threads ${ncpus} \
	--memory ${memory} \
	--tmp-dir ${tmp_work_dir} \
	2> ${log_dir}/megahit_err.log \
	> ${log_dir}/megahit_out.log
  #
  _info "MEGAHIT END."
  _done
}

Cleanup () {
    _info "CLEAN MEGAHIT OUTPUT"
    _info "megahit log files are in [${out_dir}/.megahit]"
    mkdir -p ${out_dir}/.megahit/
    bzip2 ${work_dir}/assembly.log
    mv ${work_dir}/{assembly.log.bz2,checkpoints.txt,done,options.json} ${out_dir}/.megahit/
    #
    _info "Moving megahit contigs output to [${out_dir}]"
    mv ${work_dir}/assembly.contigs.fa ${out_dir}/
    #
    _info "compressing output to [${out_dir}/assembly.contigs.fa.gz]"
    pigz -p ${ncpus} --fast ${out_dir}/assembly.contigs.fa
    #
    _info "Computing disk space used by temp file"
    du -sh ${tmp_dir} > ${log_dir}/megahit_du.log
    _info "Removing dedicated temp directory"
    rm -rf "${tmp_work_dir}"
    rm -rf "${work_dir}"
}

Before_redo () {
    _error "something went wrong during megahit assembly"
    _error "removing dedicated working directory [${work_dir}]"
    rm -rf "${work_dir}"
    _error "removing dedicated temporary directory [${tmp_work_dir}]"
    rm -rf "${tmp_work_dir}"
}

if [[ "${BASH_SOURCE[0]}" = "$0" ]]; then
    trap Before_redo ERR
    trap Cleanup EXIT
    Main "$@"
fi
