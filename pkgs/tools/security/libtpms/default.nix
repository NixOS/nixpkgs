{ lib
, stdenv
, fetchFromGitHub
, pkg-config, autoreconfHook
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
    autoreconfHook
    pkg-config
    perl # needed for pod2man
  ];
  buildInputs = [ openssl ];

  outputs = [ "out" "lib" "man" "dev" ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-openssl"
  ] ++ lib.optionals tpm2Support [
    "--with-tpm2" # TPM2 support is flagged experimental by upstream
  ];

  meta = with lib; {
    description = "The libtpms library provides software emulation of a Trusted Platform Module (TPM 1.2 and TPM 2.0)";
    homepage = "https://github.com/stefanberger/libtpms";
    license = licenses.bsd3;
    maintainers = [ maintainers.baloo ];
  };
}
