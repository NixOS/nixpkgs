{ stdenv, fetchurl, wget, bash, coreutils }:

stdenv.mkDerivation rec {
  version = "2.25";
  name = "wgetpaste-${version}";
  src = fetchurl {
    url = "http://wgetpaste.zlin.dk/${name}.tar.bz2";
    sha256 = "1x209j85mryp3hxmv1gfsbvw03k306k5fa65ky0zxx07cs70fzka";
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
