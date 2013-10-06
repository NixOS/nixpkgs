{stdenv, fetchurl, wget, bash, coreutils}:
  stdenv.mkDerivation rec {
    version = "2.20";
    name = "wgetpaste-${version}";
      src = fetchurl {
        url = "http://wgetpaste.zlin.dk/${name}.tar.bz2";
        sha256 = "7a53836d02e07cefc3c2978bb129a037fa1e1222ba0e275c4e818230a6d6fb9e";
    };
    # currently zsh-autocompletion support is not installed

    prePatch = ''
      substituteInPlace wgetpaste --replace "/usr/bin/env bash" "${bash}/bin/bash"
      substituteInPlace wgetpaste --replace "LC_ALL=C wget" "LC_ALL=C ${wget}/bin/wget"
    '';

    installPhase = ''
      mkdir -p $out/bin;
      cp wgetpaste $out/bin;
    '';

    meta = {
      description = "Command-line interface to various pastebins";
      homepage = http://wgetpaste.zlin.dk/;
      license = "publicDomain";
      maintainers = with stdenv.lib.maintainers; [qknight];
      platforms = stdenv.lib.platforms.all;
    };
  }
