{ lib, stdenv, fetchFromGitHub, libtool, autoreconfHook, pkg-config
, sysfsutils
, argp-standalone
  # WARNING: DO NOT USE BEACON GENERATED VALUES AS SECRET CRYPTOGRAPHIC KEYS
  # https://www.nist.gov/programs-projects/nist-randomness-beacon
, curl ? null, libxml2 ? null, openssl ? null, withNistBeacon ? false
  # Systems that support RDRAND but not AES-NI require libgcrypt to use RDRAND as an entropy source
, libgcrypt ? null, withGcrypt ? true
, jitterentropy ? null, withJitterEntropy ? true
, libp11 ? null, opensc ? null, withPkcs11 ? true
}:

with lib;

stdenv.mkDerivation rec {
  pname = "rng-tools";
  version = "6.11";

  src = fetchFromGitHub {
    owner = "nhorman";
    repo = "rng-tools";
    rev = "v${version}";
    sha256 = "sha256-qheJaeVX2zuv0mvKEd6wcbSHFjiJE0t5hVCJiRSKm3M=";
  };

  nativeBuildInputs = [ autoreconfHook libtool pkg-config ];

  configureFlags = [
    (withFeature   withGcrypt        "libgcrypt")
    (enableFeature withJitterEntropy "jitterentropy")
    (withFeature   withNistBeacon    "nistbeacon")
    (withFeature   withPkcs11        "pkcs11")
  ];

  # argp-standalone is only used when libc lacks argp parsing (musl)
  buildInputs = [ sysfsutils ]
    ++ optionals stdenv.hostPlatform.isx86_64 [ argp-standalone ]
    ++ optionals withGcrypt        [ libgcrypt ]
    ++ optionals withJitterEntropy [ jitterentropy ]
    ++ optionals withNistBeacon    [ curl libxml2 openssl ]
    ++ optionals withPkcs11        [ libp11 openssl ];

  enableParallelBuilding = true;

  makeFlags = [
    "AR:=$(AR)" # For cross-compilation
  ] ++ optionals (withPkcs11) [
    "PKCS11_ENGINE=${opensc}/lib/opensc-pkcs11.so" # Overrides configure script paths
  ];

  doCheck = true;
  preCheck = "patchShebangs tests/*.sh";

  meta = {
    description = "A random number generator daemon";
    homepage = "https://github.com/nhorman/rng-tools";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ johnazoidberg c0bw3b ];
  };
}
