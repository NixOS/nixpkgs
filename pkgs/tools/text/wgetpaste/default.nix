{ stdenv, fetchurl, wget, bash }:

stdenv.mkDerivation rec {
  version = "2.29";
  pname = "wgetpaste";

  src = fetchurl {
    url = "http://wgetpaste.zlin.dk/${pname}-${version}.tar.bz2";
    sha256 = "1rp0wxr3zy7y2xp3azaadfghrx7g0m138f9qg6icjxkkz4vj9r22";
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
    license = stdenv.lib.licenses.publicDomain;
    maintainers = with stdenv.lib.maintainers; [ qknight domenkozar ];
    platforms = stdenv.lib.platforms.all;
  };
}
