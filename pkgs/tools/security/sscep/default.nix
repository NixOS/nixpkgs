{ lib, stdenv
, fetchFromGitHub
, autoconf
, automake
, libtool
, pkg-config
, m4
, openssl
}:

stdenv.mkDerivation rec {
  pname = "sscep";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "certnanny";
    repo = pname;
    rev = "v${version}";
    sha256 = "0q25z4s5sq97yrpv54wsrxr3vz9cd31ci04ffj6znb42scw50p62";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
    pkg-config
    m4
  ];

  buildInputs = [
    openssl
  ];

  preConfigure = "./bootstrap.sh";

  meta = with lib; {
    description = "Command line client for the SCEP protocol";
    homepage = "https://github.com/certnanny/sscep";
    license = [ licenses.bsd3 licenses.openssl licenses.vsl10 ];
    maintainers = [ maintainers.sgo ];
  };
}
