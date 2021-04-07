{ lib, stdenv, fetchurl, wget, bash }:

stdenv.mkDerivation rec {
  version = "2.30";
  pname = "wgetpaste";

  src = fetchurl {
    url = "http://wgetpaste.zlin.dk/${pname}-${version}.tar.bz2";
    sha256 = "14k5i6j6f34hcf9gdb9cnvfwscn0ys2dgd73ci421wj9zzqkbv73";
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
    homepage = "http://wgetpaste.zlin.dk/";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ qknight domenkozar ];
    platforms = lib.platforms.all;
  };
}
