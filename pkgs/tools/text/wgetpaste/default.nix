{ lib, stdenv, fetchurl, wget, bash }:

stdenv.mkDerivation rec {
  pname = "wgetpaste";
  version = "2.32";

  src = fetchurl {
    url = "https://github.com/zlin/wgetpaste/releases/download/${version}/wgetpaste-${version}.tar.xz";
    sha256 = "04yv1hndxhrc5axwiw1yy0yrw1kli5fk4yj4267l7xdwqzxvl7b2";
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
    homepage = "https://github.com/zlin/wgetpaste";
    license = lib.licenses.publicDomain;
    maintainers = with lib.maintainers; [ qknight domenkozar ];
    platforms = lib.platforms.all;
  };
}
