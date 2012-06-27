{stdenv, fetchurl, wget, bash, coreutils}:
  stdenv.mkDerivation rec {
    version = "2.20";
    name = "wgetpaste-${version}";
      src = fetchurl {
        url = "http://wgetpaste.zlin.dk/${name}.tar.bz2";
        sha256 = "0niv1wpj2xhn40c3hffj1fklx5rmnl67jzd872487gm3zibjb0xv";
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
      description = "wgetpaste";
      homepage = http://wgetpaste.zlin.dk/;
      license = "publicDomain";
      maintainers = with stdenv.lib.maintainers; [qknight];
    };
  }
