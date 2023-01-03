{ lib, stdenv, fetchurl, wget, bash }:

stdenv.mkDerivation rec {
  pname = "wgetpaste";
  version = "2.33";

  src = fetchurl {
    url = "https://github.com/zlin/wgetpaste/releases/download/${version}/wgetpaste-${version}.tar.xz";
    sha256 = "sha256-6TWdhKOmO7vRKGIVNcUwLy46heI6UiAOgej6ubd+lxs=";
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
