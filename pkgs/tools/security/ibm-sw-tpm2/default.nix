{ stdenv, fetchurl, lib, openssl }:

stdenv.mkDerivation rec {
  pname = "ibm-sw-tpm2";
  version = "1661";

  src = fetchurl {
    url = "mirror://sourceforge/ibmswtpm2/ibmtpm${version}.tar.gz";
    sha256 = "sha256-VRRZKK0rJPNL5qDqz5+0kuEODqkZuEKMch+pcOhdYUc=";
  };

  buildInputs = [ openssl ];

  sourceRoot = "src";

  prePatch = ''
    # Fix hardcoded path to GCC.
    substituteInPlace makefile --replace /usr/bin/gcc "${stdenv.cc}/bin/cc"

    # Remove problematic default CFLAGS.
    substituteInPlace makefile \
      --replace -Werror "" \
      --replace -O0 "" \
      --replace -ggdb ""
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp tpm_server $out/bin
  '';

  meta = with lib; {
    description = "IBM's Software TPM 2.0, an implementation of the TCG TPM 2.0 specification";
    homepage = "https://sourceforge.net/projects/ibmswtpm2/";
    platforms = platforms.linux;
    maintainers = with maintainers; [ delroth ];
    license = licenses.bsd3;
  };
}
