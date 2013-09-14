{stdenv, which, coreutils, perl, fetchurl, perlPackages, makeWrapper, diffutils , writeScriptBin, writeTextFile, bzip2}:

# quick usage:
# storeBackup.pl --sourceDir /home/user --backupDir /tmp/my_backup_destination
# Its slow the first time because it compresses all files bigger than 1k (default setting)
# The backup tool is bookkeeping which files got compressed

# btrfs warning: you may run out of hardlinks soon

# known impurity: test cases seem to bu using /tmp/storeBackup.lock ..

let dummyMount = writeScriptBin "mount" "#!/bin/sh";
in

stdenv.mkDerivation {

  name = "store-backup-3.4";

  enableParallelBuilding = true;

  buildInputs = [ perl makeWrapper ];

  src = fetchurl {
    url = http://download.savannah.gnu.org/releases/storebackup/storeBackup-3.4.tar.bz2;
    sha256 = "101k3nhyfjj8y8hg0v0xqxsr4vlcfkmlczgbihvlv722fb7n5gi3";
  };

  installPhase = ''
    ensureDir $out/scripts
    mv * $out
    mv $out/_ATTENTION_ $out/doc
    mv $out/{correct.sh,cron-storebackup} $out/scripts

    find $out -name "*.pl" | xargs sed -i \
      -e 's@/bin/pwd@${coreutils}/bin/pwd@' \
      -e 's@/bin/sync@${coreutils}/bin/sync@' \
      -e '1 s@/usr/bin/env perl@${perl}/bin/perl@'

    for p in $out/bin/*
      do wrapProgram "$p" \
      --prefix PERL5LIB ":" "${perlPackages.DBFile}/lib/perl5/site_perl" \
      --prefix PATH ":" "${which}/bin:${bzip2}/bin"
    done

    patchShebangs $out
    # do a dummy test ensuring this works

    PATH=$PATH:${dummyMount}/bin


    ## test it
    backup_init(){
      mkdir backup
    }
    latestBackup(){
      echo backup/default/$(ls -1 backup/default | sort | tail -n 1)
    }
    backup_make(){
      # $1=source
      $out/bin/storeBackup.pl --sourceDir "$1" --backupDir "backup"
    }
    backup_restore_latest(){
      $out/bin/storeBackupRecover.pl -b "$(latestBackup)" -t "$1" -r /
    }

    backup_verify_integrity_latest(){
      $out/bin/storeBackupCheckBackup.pl -c "$(latestBackup)"
    }
    backup_verify_latest(){
      $out/bin/storeBackupCheckSource.pl -s "$1" -b "$(latestBackup)"
    }

    . ${import ../test-case.nix { inherit diffutils writeTextFile; }}
    backup_test backup 100M
'';

  meta = {
    description = "Storebackup is a backup suite that stores files on other disks";
    homepage = http://savannah.nongnu.org/projects/storebackup;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
