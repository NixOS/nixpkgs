{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, libtool
, pkg-config
, psmisc
, argp-standalone
, openssl
, jitterentropy, withJitterEntropy ? true
  # WARNING: DO NOT USE BEACON GENERATED VALUES AS SECRET CRYPTOGRAPHIC KEYS
  # https://www.nist.gov/programs-projects/nist-randomness-beacon
, curl, jansson, libxml2, withNistBeacon ? false
, libp11, opensc, withPkcs11 ? true
, rtl-sdr, withRtlsdr ? true
}:

stdenv.mkDerivation rec {
  pname = "rng-tools";
  version = "6.15";

  src = fetchFromGitHub {
    owner = "nhorman";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-km+MEng3VWZF07sdvGLbAG/vf8/A1DxhA/Xa2Y+LAEQ=";
  };

  nativeBuildInputs = [ autoreconfHook libtool pkg-config ];

  configureFlags = [
    (lib.enableFeature (withJitterEntropy) "jitterentropy")
    (lib.withFeature   (withNistBeacon)    "nistbeacon")
    (lib.withFeature   (withPkcs11)        "pkcs11")
    (lib.withFeature   (withRtlsdr)        "rtlsdr")
  ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isMusl [ argp-standalone ]
    ++ lib.optionals withJitterEntropy [ jitterentropy ]
    ++ lib.optionals withNistBeacon    [ curl jansson libxml2 ]
    ++ lib.optionals withPkcs11        [ libp11 libp11.passthru.openssl ]
    ++ lib.optionals withRtlsdr        [ rtl-sdr ];

  enableParallelBuilding = true;

  makeFlags = [
    "AR:=$(AR)" # For cross-compilation
  ] ++ lib.optionals withPkcs11 [
    "PKCS11_ENGINE=${opensc}/lib/opensc-pkcs11.so" # Overrides configure script paths
  ];

  doCheck = true;
  preCheck = "patchShebangs tests/*.sh";
  nativeCheckInputs = [ psmisc ]; # rngtestjitter.sh needs killall

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    set -o pipefail
    $out/bin/rngtest --version | grep $version
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "A random number generator daemon";
    homepage = "https://github.com/nhorman/rng-tools";
    changelog = "https://github.com/nhorman/rng-tools/releases/tag/v${version}";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ johnazoidberg c0bw3b ];
  };
}
