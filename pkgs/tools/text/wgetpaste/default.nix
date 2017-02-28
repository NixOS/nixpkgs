{ stdenv, fetchurl, wget, bash, coreutils }:

stdenv.mkDerivation rec {
  version = "2.28";
  name = "wgetpaste-${version}";

  src = fetchurl {
    url = "http://wgetpaste.zlin.dk/${name}.tar.bz2";
    sha256 = "1hh9svyypqcvdg5mjxyyfzpdzhylhf7s7xq5dzglnm4injx3i3ak";
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
    maintainers = with stdenv.lib.maintainers; [ qknight domenkozar ndowens ];
    platforms = stdenv.lib.platforms.all;
  };
}
