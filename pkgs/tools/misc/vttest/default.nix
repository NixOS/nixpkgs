{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "vttest";
  version = "20221229";

  src = fetchurl {
    urls = [
      "https://invisible-mirror.net/archives/${pname}/${pname}-${version}.tgz"
      "ftp://ftp.invisible-island.net/${pname}/${pname}-${version}.tgz"
    ];
    sha256 = "sha256-a2oQmsrwVpz3Zg0g3NFTuD4yjpuT2uTnO5hbvMaxi/g=";
  };

  meta = with lib; {
    description = "Tests the compatibility of so-called 'VT100-compatible' terminals";
    homepage = "https://invisible-island.net/vttest/";
    license = licenses.mit;
    platforms = platforms.all;
  };
}

