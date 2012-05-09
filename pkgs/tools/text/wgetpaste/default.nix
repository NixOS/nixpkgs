{stdenv, fetchurl, wget, bash, coreutils}:
  stdenv.mkDerivation rec {
    version = "2.19";
    name = "wgetpaste-${version}";
      src = fetchurl {
        url = "http://wgetpaste.zlin.dk/${name}.tar.bz2";
        sha256 = "bb832557fca3be838838a87d790cb535974ea70bd2393818201676212f0f3b5a";
    };
    # currently zsh-autocompletion support is not installed

    prePatch = ''
      substituteInPlace wgetpaste --replace "/usr/bin/env bash" "${bash}/bin/bash"
    '';

    installPhase = ''
      mkdir -p $out/bin;
      cp wgetpaste $out/bin;
    '';

    meta = {
      description = "wgetpaste";
      homepage = http://wgetpaste.zlin.dk/;
      license = "publicDomain";
      maintainers = with stdenv.lib.maintainers; [qknight];
    };
  }
