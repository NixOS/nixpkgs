{ pkgs, stdenv } :

let inherit (pkgs) stdenv runCommand perl lib;

in

{

  /* 

    usage example creating a derivation installing ruby, sup and a lib:

    packageOverrides = {
      rubyCollection = collection {
        name = "ruby";
        list = let l = rubyLibs; in 
          [ pkgs.ruby l.chronic l.sup ];
      };
    }

  */
  collection = {list, name} : runCommand "collection-${name}" {} ''
    mkdir -p $out/nix-support
    echo ${builtins.toString list} > $out/nix-support/propagated-user-env-packages
  '';

  /* creates a derivation symlinking references C/C++ libs into one include and lib directory called $out/cdt-envs/${name}
     then you can
     ln -s ~/.nix-profile/cdt-envs/name ./nix-deps
     and add .nix-deps/{libs,includes} to IDE's such as Eclipse/ Netbeans etc.
     To update replace library versions just replace the symlink
  */
  cdtEnv = { name, buildInputs }:
    stdenv.mkDerivation {
     name = "cdt-env-${name}";
     inherit buildInputs;
     phases = "installPhase";
     installPhase = ''
      set -x
      # requires bash4
      PATH=$PATH:${pkgs.pkgconfig}/bin

      perlScript=$(dirname $(dirname ${builtins.getEnv "NIXPKGS_ALL"}))/build-support/buildenv/builder.pl
      # now collect includes and lib paths

      # probably the nix hooks work best, so reuse them by reading NIX_CFLAGS_COMPILE and NIX_LDFLAGS

      PKG_CONFIG_KNOWN_PACKAGES=$(pkg-config --list-all | sed 's/ .*//')

      declare -A INCLUDE_PATHS
      declare -A LIB_PATHS
      declare -A LIBS
      declare -A CFLAGS_OTHER

      PKG_CONFIG_LIBS="$(pkg-config --libs $PKG_CONFIG_KNOWN_PACKAGES)"
      PKG_CONFIG_CFLAGS="$(pkg-config --cflags $PKG_CONFIG_KNOWN_PACKAGES)"

      for i in $NIX_CFLAGS_COMPILE $PKG_CONFIG_CFLAGS; do
        echo i is $i
        case $i in
          -I*) INCLUDE_PATHS["''${i/-I/}"]= ;;
          *) CFLAGS_OTHER["''${i}"]= ;;
        esac
          echo list is now ''${!INCLUDE_PATHS[@]}
      done

      for i in $NIX_LDFLAGS $PKG_CONFIG_LIBS; do
        case $i in
          -L*)
          LIB_PATHS["''${i/-L/}"]= ;;
        esac
      done

      for i in $NIX_LDFLAGS $PKG_CONFIG_LIBS; do
        echo chekcing $i
        case $i in
          -l*) LIBS["''${i}"]= ;;
        esac;
      done

      # build output env

      target="$out/cdt-envs/${name}"

      link(){
        echo "link !!!!"
          echo $1
          echo $2
        (
          export out="$1"
          export paths="$2"

          export ignoreCollisions=1
          export manifest=
          export pathsToLink=/
          ${perl}/bin/perl $perlScript
        )
      }

      ensureDir $target/{include,lib}
      link $target/lib "$(echo "''${!LIB_PATHS[@]}")"
      link $target/include "$(echo "''${!INCLUDE_PATHS[@]}")"
      echo "''${!LIBS[@]}" > $target/libs
      echo "''${!CFLAGS_OTHER[@]}" > $target/cflags-other
      echo "''${PKG_CONFIG_PATH}" > $target/PKG_CONFIG_PATH
      echo "''${PATH}" > $target/PATH
    '';
  };


  # build a debug version of a package
  debugVersion = pkg: lib.overrideDerivation pkg (attrs: {

    prePhases = ["preHook"] ++ lib.optionals (pkgs ? prePhases) pkgs.prePhases;

    dontStrip = true;

    NIX_STRIP_DEBUG=0;
    CFLAGS="-ggdb -O0";
    CXXFLAGS="-ggdb -O0";

    preHook = ''
      s=$out/src
      mkdir -p $s; cd $s;
      export TMP=$s
      export TEMP=$s

      for var in CFLAGS CXXFLAGS NIX_CFLAGS_COMPILE; do
        declare -x "$var=''${!var} -ggdb -O0"
      done
      echo "file should tell that executable has not been strippee"
    '';

  });
}
