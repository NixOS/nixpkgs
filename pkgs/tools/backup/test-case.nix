# while this test suite is not perfect it will at least provide some guarantees
# that basic features should be fine ..

/*
  In order to use the suite you have to define the following functions

    backup_init
    backup_make source
    backup_restore_latest target
    backup_verify_integrity_latest
    backup_verify_latest source

  use true if a backup system does not implement a feature

  TODO: add test cases for all backup solutions shipping with nixpkgs

  This does not replace the test suites shipping with the backup solutions!
*/

{diffutils, writeTextFile}:

writeTextFile {
  name = "backup-test-case";
  text = ''
  backup_run_tests_on_source(){
    local test="$1"
    local source="$2"
    local backup="$3"
    echo =========
    echo RUNNING TEST "$test" source: "$source"
    mkdir restored

    backup_make "$source" backup

    { # verify that restoring works
      backup_restore_latest restored
      ${diffutils}/bin/diff -r "$source" restored
      # diff does not make a difference for symlinks, so list them and compare
      # lists
      ( cd "$source"; find /var/www/ -type l) | sort > 1
      ( cd "$restored"; find /var/www/ -type l) | sort > 2
      diff 1 2
    }

    { # verify that backup tool thinks so, too:
      backup_verify_latest "$source" backup
      # using different source verification must fail:
      ! backup_verify_latest "$TMP" backup
    }

    backup_verify_integrity_latest backup

    chmod -R +w restored
    rm -fr restored
  }

  backup_test(){
    set -x
    # allow getting run time to compare backup solutions
    echo "START $(date)"

    local block_size="$2"

    backup_init

    if [ -z "$SKIP_SYMLINK_TEST" ]; then
      { # create first test case directory contentents
        testDir=$TMP/test-1a
        mkdir $testDir
        echo X > $testDir/X
        ln -s ./X $testDir/Y
      }

      backup_run_tests_on_source 'test 1a: backup, restore' "$testDir" "$backup"
    fi

    if [ -z "$SKIP_EMPTY_DIR_TEST" ]; then
      { # create first test case directory contentents
        testDir=$TMP/test-1b
        mkdir -p $testDir/empty-directory
      }

      backup_run_tests_on_source 'test 1b: backup, restore' "$testDir" "$backup"
    fi

    testDir=$TMP/test-huge-blocks
    mkdir $testDir
    # test huge blocks, according to docs files bigger than 100MB get split
    # into pieces
    dd if=/dev/urandom bs=1M of=block-0 count=20
    dd if=/dev/urandom bs="$block_size" of=block-1 count=1
    dd if=/dev/urandom bs="$block_size" of=block-2 count=1
    cat block-0 block-0 block-0 block-1 block-2 block-0 block-0 block-0 > $testDir/block
    backup_run_tests_on_source 'test 1 with huge block' $testDir

    cat block-2 block-0 block-0 block-1 > $testDir/block
    backup_run_tests_on_source 'test 1 with huge block reversed' $testDir

    backup_run_tests_on_source 'test 2: backup, restore' $out
    backup_run_tests_on_source 'test 3: backup, restore' $out
    backup_run_tests_on_source 'test 4: backup diffutils to same backup locations, restore' ${diffutils}
    echo "STOP $(date)"
  }
  '';
}
