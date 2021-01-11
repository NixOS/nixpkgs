{ lib, stdenv, fetchFromGitHub, autoreconfHook, jdk

# Enable ECDSA pubkey recovery module
, enableRecovery ? true

# Enable ECDH shared secret computation (disabled by default because it is
# experimental)
, enableECDH ? false

# Enable libsecp256k1_jni (disabled by default because it requires a jdk,
# which is a large dependency)
, enableJNI ? false

}:

let inherit (stdenv.lib) optionals; in

stdenv.mkDerivation {
  pname = "secp256k1";

  # I can't find any version numbers, so we're just using the date of the
  # last commit.
  version = "2020-08-16";

  src = fetchFromGitHub {
    owner = "bitcoin-core";
    repo = "secp256k1";
    rev = "670cdd3f8be25f81472b2d16dcd228b0d24a5c45";
    sha256 = "0ak2hrr0wznl5d9s905qwn5yds7k22i28d2jp957l4a8yf8cqv3s";
  };

  buildInputs = optionals enableJNI [ jdk ];

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags =
    [ "--enable-benchmark=no" "--enable-tests=yes" "--enable-exhaustive-tests=no" ] ++
    optionals enableECDH [ "--enable-module-ecdh" "--enable-experimental" ] ++
    optionals enableRecovery [ "--enable-module-recovery" ] ++
    optionals enableJNI [ "--enable-jni" ];

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
    maintainers = with maintainers; [ chris-martin ];
    platforms = with platforms; unix;
  };
}
