{ lib
, stdenv
, numactl
, libaio
, cunit
, libuuid
, fetchFromGitHub
, gcc
, openssl
, python
}:

stdenv.mkDerivation rec {
  name = "spdk-${version}";
  version = "v18.04-pre";

  src = fetchFromGitHub {
    repo = "spdk";
    owner = "spdk";
    rev = "a3f8876777762f9b99544b78ee0b24ff66266c5c";
    sha256 = "1hb22h8c8b3q91ypfj084ic8gw1fibhfckivfgl334hbbxvay0j0";
    fetchSubmodules = true;
  };

  CFLAGS = "-msha -msse4.1 -mssse3";

  buildInputs = [
    cunit
    gcc
    libaio
    libuuid
    numactl
    python
    openssl
  ];

  meta = with stdenv.lib; {
    homepage = "http://www.spdk.io";
    description = "The Storage Performance Development Kit (SPDK)";
    longDescription = ''
      The Storage Performance Development Kit (SPDK) provides a set of tools and
      libraries for writing high performance, scalable, user-mode storage
      applications.
    '';
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ avalent ];
    platforms = platforms.linux;
  };
}
