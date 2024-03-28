{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "olivetin";
  version = "2023.03.25";
  os = "linux";
  arch = "amd64";

  src = fetchurl {
    url = "https://github.com/OliveTin/OliveTin/releases/download/${version}/OliveTin-${os}-${arch}.tar.gz";
    hash = "sha256-s+6Em0r03dicTO4BrgfuaJYog2+USJlvFOGnAw9bD3E=";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp OliveTin $out/bin/
  '';
  meta = {
    description = "OliveTin gives safe and simple access to predefined shell commands from a web interface.";
    homepage = "https://www.olivetin.app/";
    license = lib.licenses.agpl3Only;
  };
}
