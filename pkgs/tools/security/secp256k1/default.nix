{ stdenv, fetchFromGitHub, autoreconfHook, jdk

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

stdenv.mkDerivation rec {
  name = "secp256k1-${version}";

  # I can't find any version numbers, so we're just using the date of the
  # last commit.
  version = "2017-12-18";

  src = fetchFromGitHub {
    owner = "bitcoin-core";
    repo = "secp256k1";
    rev = "f54c6c5083307b18224c953cf5870ea7ffce070b";
    sha256 = "0bxqmimm627g9klalg1vdbspmn52588v4a6cli3p8bn84ibsnzbm";
  };

  buildInputs = optionals enableJNI [ jdk ];

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags =
    [ "--enable-benchmark=no" "--enable-tests=no" "--enable-exhaustive-tests=no" ] ++
    optionals enableECDH [ "--enable-module-ecdh" "--enable-experimental" ] ++
    optionals enableRecovery [ "--enable-module-recovery" ] ++
    optionals enableJNI [ "--enable-jni" ];

  meta = with stdenv.lib; {
    description = "Optimized C library for EC operations on curve secp256k1";
    longDescription = ''
      Optimized C library for EC operations on curve secp256k1. Part of
      Bitcoin Core. This library is a work in progress and is being used
      to research best practices. Use at your own risk.
    '';
    homepage = https://github.com/bitcoin-core/secp256k1;
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ chris-martin ];
    platforms = with platforms; unix;
  };
}
