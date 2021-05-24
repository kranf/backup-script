# backup local files to destination.

Only incremental diff from previous backup is copied.

Each backup has a date: ```directory-yyyyMMddTHHmm```

```directory-current``` repertory is a link pointing to the latest backup.

New backup hard-links non modified files to ```directory-current```

## How to use

'''backup.sh -i include.lst [-e exclude.lst] -d destdir
  -h    print usage
  -i    path to the list of directories to backup
  -e    path the list of excluded patterns as supported by rsync
  -d    path the backup destination dir'''
