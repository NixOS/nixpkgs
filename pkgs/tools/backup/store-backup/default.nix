{stdenv, which, coreutils, perl, fetchurl, perlPackages, makeWrapper, diffutils , writeScriptBin, bzip2}:

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
    mkdir -p $out/scripts
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


    { # simple sanity test, test backup/restore of simple store paths

      mkdir backup

      backupRestore(){
        source="$2"
        echo =========
        echo RUNNING TEST "$1" source: "$source"
        mkdir restored

        $out/bin/storeBackup.pl --sourceDir "$source" --backupDir backup
        latestBackup=backup/default/$(ls -1 backup/default | sort | tail -n 1)
        $out/bin/storeBackupRecover.pl -b "$latestBackup" -t restored -r /
        ${diffutils}/bin/diff -r "$source" restored

        # storeBackupCheckSource should return 0
        $out/bin/storeBackupCheckSource.pl -s "$source" -b "$latestBackup"
        # storeBackupCheckSource should return not 0 when using different source
        ! $out/bin/storeBackupCheckSource.pl -s $TMP -b "$latestBackup"

        # storeBackupCheckBackup should return 0
        $out/bin/storeBackupCheckBackup.pl -c "$latestBackup"

        chmod -R +w restored
        rm -fr restored
      }

      testDir=$TMP/testDir

      mkdir $testDir
      echo X > $testDir/X
      ln -s ./X $testDir/Y

      backupRestore 'test 1: backup, restore' $testDir

      # test huge blocks, according to docs files bigger than 100MB get split
      # into pieces
      dd if=/dev/urandom bs=100M of=block-1 count=1
      dd if=/dev/urandom bs=100M of=block-2 count=1
      cat block-1 block-2 > $testDir/block
      backupRestore 'test 1 with huge block' $testDir

      cat block-2 block-1 > $testDir/block
      backupRestore 'test 1 with huge block reversed' $testDir

      backupRestore 'test 2: backup, restore' $out
      backupRestore 'test 3: backup, restore' $out
      backupRestore 'test 4: backup diffutils to same backup locations, restore' ${diffutils}
    }
  '';

  meta = {
    description = "Storebackup is a backup suite that stores files on other disks";
    homepage = http://savannah.nongnu.org/projects/storebackup;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
