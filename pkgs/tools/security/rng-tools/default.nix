{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, libtool
, pkg-config
, argp-standalone ? null
, openssl
, jitterentropy ? null, withJitterEntropy ? true
  # WARNING: DO NOT USE BEACON GENERATED VALUES AS SECRET CRYPTOGRAPHIC KEYS
  # https://www.nist.gov/programs-projects/nist-randomness-beacon
, curl ? null, jansson ? null, libxml2 ? null, withNistBeacon ? false
, libp11 ? null, opensc ? null, withPkcs11 ? true
, librtlsdr ? null, withRtlsdr ? true
}:

assert (stdenv.hostPlatform.isMusl) -> argp-standalone != null;
assert (withJitterEntropy) -> jitterentropy != null;
assert (withNistBeacon) -> curl != null && jansson != null && libxml2 != null;
assert (withPkcs11) -> libp11 != null && opensc != null;
assert (withRtlsdr) -> librtlsdr != null;

with lib;

stdenv.mkDerivation rec {
  pname = "rng-tools";
  version = "6.14";

  src = fetchFromGitHub {
    owner = "nhorman";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-NTXp2l5gVxKhO4Gqcy4VzomYU5B3HydkefMvdzypK8M=";
  };

  nativeBuildInputs = [ autoreconfHook libtool pkg-config ];

  configureFlags = [
    (enableFeature (withJitterEntropy) "jitterentropy")
    (withFeature   (withNistBeacon)    "nistbeacon")
    (withFeature   (withPkcs11)        "pkcs11")
    (withFeature   (withRtlsdr)        "rtlsdr")
  ];

  buildInputs = [ openssl ]
    ++ optionals (stdenv.hostPlatform.isMusl) [ argp-standalone ]
    ++ optionals (withJitterEntropy) [ jitterentropy ]
    ++ optionals (withNistBeacon)    [ curl jansson libxml2 ]
    ++ optionals (withPkcs11)        [ libp11 openssl ]
    ++ optionals (withRtlsdr)        [ librtlsdr ];

  enableParallelBuilding = true;

  makeFlags = [
    "AR:=$(AR)" # For cross-compilation
  ] ++ optionals (withPkcs11) [
    "PKCS11_ENGINE=${opensc}/lib/opensc-pkcs11.so" # Overrides configure script paths
  ];

  doCheck = true;
  preCheck = "patchShebangs tests/*.sh";

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    set -o pipefail
    $out/bin/rngtest --version | grep $version
    runHook postInstallCheck
  '';

  meta = {
    description = "A random number generator daemon";
    homepage = "https://github.com/nhorman/rng-tools";
    changelog = "https://github.com/nhorman/rng-tools/releases/tag/v${version}";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ johnazoidberg c0bw3b ];
  };
}
