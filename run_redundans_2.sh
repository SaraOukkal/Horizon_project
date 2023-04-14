##!/usr/bin/env bash

set -eEuo pipefail
readonly EXE="$(basename "$0")"

IFS=$'\n\t'

Usage() {
    cat <<END_DOC
Usage:
    bash ${EXE}

Description:
    Reduce assembly to haplotype using redundans.

Options:
   -h, --help:     Display this help message
   -s, --sample:   Sample ID
   -c, --cpus:     Number of parallel proc.

Author:
    Samuel Barreto, 2020-12-03

END_DOC

    exit 0
}


while [ "$#" -gt 0 ]; do
  case "$1" in
    -h|--help) Usage ;;
    -s|--sample) arg_sample="$2" ; shift 2;;
    -c|--cpus) arg_cpus="$2"   ; shift 2;;
    --) shift 1 && break ;;
    -*) echo "unknown option: $1" >&2; exit 1;;
  esac
done

# should be absolute file name
readonly LOG_FILE="$(/beegfs/data/soukkal/Thesis/Horizon/Assembly/logs/${arg_sample}/.log/$EXE.log)"


_date() { date --iso-8601=seconds ;}
__msg() {
  local name="$1" && shift;
  local msg="$@"
  printf "# [${EXE}] ($(_date)) ${name}: ${msg}\n" | tee -a "$LOG_FILE" >&2 ;
}

_info()    { __msg "INFO"  $@ ; }
_warn()    { __msg "WARN"  $@ ; }
_error()   { __msg "ERROR" $@ ; }
_fatal()   { __msg "FATAL" $@ && exit 1 ; }

__currently_doing=""
_doing () { __currently_doing="$1"; _info "${__currently_doing} ..." ; }
_done ()  { _info "${__currently_doing}: done." ; }

# check env ----------------------------------------------------------
is_in_path () {
  if command -v $1 > /dev/null 2>&1; then
    _info "available '$1'? yes."
  else
    _fatal "'available $1'? no."
  fi
}

are_in_path () {
  while [ "$#" -gt 0 ]; do
    is_in_path "$1"; shift
  done
}


pushd () { command pushd "$@" > /dev/null ; }
popd () { command popd "$@" > /dev/null ; }

# --------------------------------------------------------------------
if [ -d "/beegfs/data/soukkal/Thesis/Horizon/Assembly/" ]; then
  tmp_dir="/beegfs/data/soukkal/Thesis/Horizon/Assembly/${arg_sample}"
else
  tmp_dir="/beegfs/data/soukkal/Thesis/Horizon/Assembly/${arg_sample}"
  _warn "Writing on /tmp. Make sure it is cleaned up (hostname: $(hostname))."
fi
tmp_work_dir="${tmp_dir}/scaffolding"
mkdir -p ${tmp_work_dir}

Panic () {
  _warn "Something went wrong"
}

Cleanup () {
  _info "Exiting."
  _doing "Removing tmp working directory"
  (rm -rf "${tmp_work_dir}")
  _done
  _info "See ya."
}

trap Panic SIGINT
trap Panic ERR
trap Cleanup EXIT

# BODY ---------------------------------------------------------------

_doing "Checking environment"
are_in_path "redundans.py" "pigz" "gzip" "cat" "pushd" "popd" "find" "bzip2"
_done

_doing "Concatenating reads libraries"
pushd /beegfs/data/soukkal/Thesis/Horizon/Assembly/${arg_sample}
cp /beegfs/data/soukkal/Thesis/Horizon/Assembly/${arg_sample}/reads_1.trim.fq.gz /beegfs/data/soukkal/Thesis/Horizon/Assembly/${arg_sample}/reads_2.trim.fq.gz ${tmp_work_dir}/
popd
_done


contigs="$(realpath /beegfs/data/soukkal/Thesis/Horizon/Assembly/${arg_sample}/Assembly/assembly.contigs.fa)"
redundans_log="$(realpath /beegfs/data/soukkal/Thesis/Horizon/Assembly/${arg_sample}/.log/redundans.log)"
output_dir="$(realpath /beegfs/data/soukkal/Thesis/Horizon/Assembly/${arg_sample}/Assembly"

_doing "Running redundans" # -----------------------------------------

pushd ${tmp_work_dir}
redundans.py \
     --verbose \
     --fastq reads_{1,2}.fq.gz \
     --fasta ${contigs} \
     --usebwa \
     --outdir ${output_dir} \
     --iter 4 \
     --joins 3 \
     --threads ${arg_cpus} \
     --mem 16 \
     --log ${redundans_log} \
     --tmp ${tmp_work_dir}

_done # --------------------------------------------------------------


_doing "Removing clutter" # ------------------------------------------
pushd redundans

_info "Clear and compress log files"
mkdir -p .log
find . -type f -name '*.log' | while read log; do
  bzip2 "${log}" && mv ${log}.bz2 .log/
done

_info "Remove contigs related files"; \
  find . -type f -name 'contigs.*' -exec rm {}     \;
_info "Compress tsv files"; \
  find . -type f -name '*.tsv' -exec bzip2 {}  \;
_info "Remove scaffolding intermediates"; \
  find . -type d -name '_sspace.*' | xargs -I{} rm -rf {} \;
_info "Compress fasta output"; \
  find . -type f -name '*.fa' -exec pigz -p ${arg_cpus} -6 {}  \;
_info "Removing fasta index"; \
  find . -type f -name '*.fai' -exec rm {}  \;
_info "Removing dead symlink"; \
  find . -xtype l -exec rm {} \;
_info "Renaming filled scaffolds."; \
  mv _gapcloser.*.fa.gz scaffolds.fa.gz

popd                            # now in /data/horizon/SAMPLE/scaffolding

_info "Copying output to /beegfs/data/soukkal/Thesis/Horizon/Assembly/${arg_sample}/Assembly"
rsync -avhr --verbose --progress redundans/ ${output_dir}/

popd
_done # --------------------------------------------------------------
