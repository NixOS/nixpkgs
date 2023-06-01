{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libcap-ng";
  version = "0.8.3";

  src = fetchurl {
    url = "https://people.redhat.com/sgrubb/libcap-ng/libcap-ng-${version}.tar.gz";
    sha256 = "sha256-vtb2hI4iuy+Dtfdksq7w7TkwVOgDqOOocRyyo55rSS0=";
  };

  configureFlags = [
    "--without-python"
  ];

  meta = with lib; {
    description = "Library for working with POSIX capabilities";
    homepage = "https://people.redhat.com/sgrubb/libcap-ng/";
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };
}
