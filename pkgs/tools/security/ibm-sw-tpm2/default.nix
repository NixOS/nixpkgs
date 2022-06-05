{ stdenv, fetchurl, fetchpatch, lib, openssl }:

stdenv.mkDerivation rec {
  pname = "ibm-sw-tpm2";
  version = "1661";

  src = fetchurl {
    url = "mirror://sourceforge/ibmswtpm2/ibmtpm${version}.tar.gz";
    sha256 = "sha256-VRRZKK0rJPNL5qDqz5+0kuEODqkZuEKMch+pcOhdYUc=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/kgoldman/ibmswtpm2/commit/e6684009aff9c1bad38875e3319c2e02ef791424.patch";
      sha256 = "1flzlri807c88agmpb0w8xvh5f16mmqv86xw4ic4z272iynzd40j";
    })
  ];

  patchFlags = [ "-p2" ];

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
