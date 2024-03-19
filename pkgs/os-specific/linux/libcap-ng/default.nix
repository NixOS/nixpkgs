{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libcap-ng";
  version = "0.8.4";

  src = fetchurl {
    url = "https://people.redhat.com/sgrubb/libcap-ng/libcap-ng-${version}.tar.gz";
    sha256 = "sha256-aFgdOzjnVTy29t33gTsfyZ5ShW8hQh97R3zlq9JgWoo=";
  };

  outputs = [ "out" "dev" "man" ];

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
