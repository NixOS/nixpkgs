{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "secp256k1";

  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "bitcoin-core";
    repo = "secp256k1";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-atq34GnWkSkWTWxZP4PCSF3hIjGFhQ534E+WUtLRkiM=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [
    "--enable-benchmark=no"
    "--enable-module-recovery"
  ];

  doCheck = true;

  meta = with lib; {
    description = "Optimized C library for EC operations on curve secp256k1";
    longDescription = ''
      Optimized C library for EC operations on curve secp256k1. Part of
      Bitcoin Core. This library is a work in progress and is being used
      to research best practices. Use at your own risk.
    '';
    homepage = "https://github.com/bitcoin-core/secp256k1";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ ];
    platforms = with platforms; all;
  };
}
