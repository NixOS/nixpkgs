{ lib
, stdenv
, fetchFromGitHub
, pkgconfig
, autoconf, automake, libtool
, openssl, perl
, tpm2Support ? false
}:

stdenv.mkDerivation rec {
  pname = "libtpms";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "stefanberger";
    repo = "libtpms";
    rev = "v${version}";
    sha256 = "sha256-nZSBD3WshlZHVMBFmDBBdFkhBjNgtASfg6+lYOOAhZ8=";
  };

  nativeBuildInputs = [
    autoconf automake libtool
    pkgconfig
    perl # needed for pod2man
  ];
  buildInputs = [
    openssl
  ];

  outputs = [
    "out"
    "lib"
    "man"
    "dev"
  ];
  patchPhase = ''
    patchShebangs bootstrap.sh
  '';
  preConfigure = ''
    ./bootstrap.sh
  '';

  enableParallelBuilding = true;

  configureFlags = [
    "--with-openssl"
  ] ++ lib.optionals tpm2Support [
    "--with-tpm2" # TPM2 support is flagged experimental by upstream
  ];

  meta = {
    description = "The libtpms library provides software emulation of a Trusted Platform Module (TPM 1.2 and TPM 2.0)";
    homepage = https://github.com/stefanberger/libtpms;
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.baloo ];
  };
}
