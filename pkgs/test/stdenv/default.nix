args@{ lib, stdenv }:

# For development, copy setup.sh to setup-2.sh and edit, then use:
# let
#   stdenv = args.stdenv.override { setupScript = ../../stdenv/generic/setup-2.sh; };
# in

lib.recurseIntoAttrs {

  simple-derivation = stdenv.mkDerivation {
    name = "test-simple-derivation";
    dontUnpack = true;
    installPhase = "touch $out";
    doInstallCheck = true;
    installCheckPhase = "echo ok";
  };

  simulated-output-change-failure = stdenv.mkDerivation {
    name = "test-simulated-output-change-failure";
    dontUnpack = true;
    buildPhase = ''
      mkdir -p $out
      saveOutputHashes

      echo Checking that out is unchanged...
      checkOutputHashes
      echo OK

      echo Checking that new empty directory is detected...
      saveOutputHashes
      mkdir $out/new-dir
      (! checkOutputHashes) | grep new-dir
      echo OK

      echo Checking that new empty file is detected...
      saveOutputHashes
      touch $out/new-empty-file
      (! checkOutputHashes) | grep new-empty-file
      echo OK

      echo Checking that change to file is detected...
      echo "hi" >$out/changing-file
      saveOutputHashes
      echo "hello" >$out/changing-file
      (! checkOutputHashes) | grep changing-file | grep sha256
      echo OK

      echo Checking that new symlink is detected...
      saveOutputHashes
      ln -s $stdenv $out/new-symlink
      (! checkOutputHashes) | grep new-symlink | grep stdenv
      echo OK

      echo Checking that changed symlink is detected...
      ln -s $stdenv $out/changing-symlink
      saveOutputHashes
      rm $out/changing-symlink
      ln -s $stdenv/new-link $out/changing-symlink
      (! checkOutputHashes) | grep changing-symlink | grep new-link
      echo OK

      echo Checking that changed executable bit is detected...
      touch $out/changing-executable
      saveOutputHashes
      chmod a+x $out/changing-executable
      (! checkOutputHashes) | grep changing-executable
      echo OK

    '';
    installPhase = "touch $out";
  };

}
