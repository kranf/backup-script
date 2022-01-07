#!/usr/bin/bash

function get_date_formatted {
  echo $(date +%Y%m%dT%H%M%S)
}

function usage () {
  echo "./$(basename $0) -i include.lst [-e exclude.lst] -d destdir"
  echo "  -h    print usage"
  echo "  -i    path to the list of directories to backup"
  echo "  -e    path to the list of excluded patterns as supported by rsync"
  echo "  -d    path to the backup destination dir"
}

while getopts "hi:e:d:" args; do
  case "${args}" in
    h)
      usage
      exit 0
      ;;
    i)
      INCLUDED_FILES=${OPTARG}
      ;;
    e)
      EXCLUDED_PATTERNS=$(realpath ${OPTARG})
      ;;
    d)
      DEST_DIR=${OPTARG}
      ;;
    :)
      usage
      exit 1
      ;;
    ?)
      usage
      exit 1
      ;;
  esac
done

mapfile -t dir_list < "${INCLUDED_FILES}"
cd ${DEST_DIR}  # every reference to backup files are related to .

for source in "${dir_list[@]}"; do
  source_basename=$(basename $source)
  source_dated="$source_basename-$(get_date_formatted)"
  source_ref="$source_basename-current"
  link_dest=$(realpath .)/$source_ref

  echo "*****************************************************"
  echo -e "*** Starting backup of $source"
  echo "*****************************************************"

  rsync \
    --verbose \
    --recursive \
    --progress \
    --partial \
    --human-readable \
    --times \
    --links \
    --link-dest=$link_dest \
    --exclude-from=$EXCLUDED_PATTERNS \
    $source/ \
    $source_dated

    ln -sfn $source_dated $source_ref
done
