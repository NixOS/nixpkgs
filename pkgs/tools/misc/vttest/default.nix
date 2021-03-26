{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "vttest";
  version = "20210210";

  src = fetchurl {
    urls = [
      "https://invisible-mirror.net/archives/${pname}/${pname}-${version}.tgz"
      "ftp://ftp.invisible-island.net/${pname}/${pname}-${version}.tgz"
    ];
    sha256 = "sha256-D5ii4wWYKRXxUgmEw+hpjjrNUI7iEHEVKMifWn6n8EY=";
  };

  meta = with lib; {
    description = "Tests the compatibility so-called 'VT100-compatible' terminals";
    homepage = "https://invisible-island.net/vttest/";
    license = licenses.mit;
    platforms = platforms.all;
  };
}

