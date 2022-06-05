{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "vttest";
  version = "20220215";

  src = fetchurl {
    urls = [
      "https://invisible-mirror.net/archives/${pname}/${pname}-${version}.tgz"
      "ftp://ftp.invisible-island.net/${pname}/${pname}-${version}.tgz"
    ];
    sha256 = "sha256-SmWZjF4SzwjO0s/OEZrbRPqEKsFJXQ8VDyHIpnhZFaE=";
  };

  meta = with lib; {
    description = "Tests the compatibility of so-called 'VT100-compatible' terminals";
    homepage = "https://invisible-island.net/vttest/";
    license = licenses.mit;
    platforms = platforms.all;
  };
}

