{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
}:

stdenv.mkDerivation {
  pname = "secp256k1";

  # I can't find any version numbers, so we're just using the date of the
  # last commit.
  version = "unstable-2021-12-25";

  src = fetchFromGitHub {
    owner = "bitcoin-core";
    repo = "secp256k1";
    rev = "39a36db94a6f733398d4eefd4e89bcaaeb063551";
    sha256 = "1xss16608cvjaivlz7y4wzj229f1411hcbfw0lnrznl4rz4r4ah1";
  };

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [
    "--enable-benchmark=no"
    "--enable-exhaustive-tests=no"
    "--enable-experimental"
    "--enable-module-ecdh"
    "--enable-module-recovery"
    "--enable-module-schnorrsig"
    "--enable-tests=yes"
  ];

  doCheck = true;

  checkPhase = "./tests";

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
    platforms = with platforms; unix;
  };
}
