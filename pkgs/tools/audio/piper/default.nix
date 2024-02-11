{ lib
, stdenv
, fetchFromGitHub

# build time
, cmake
, pkg-config

# runtime
, fmt
, onnxruntime
, pcaudiolib
, piper-phonemize
, spdlog

# tests
, piper-train
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "piper";
  version = "2023.11.14-2";

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "piper";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-3ynWyNcdf1ffU3VoDqrEMrm5Jo5Zc5YJcVqwLreRCsI=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    "-DFMT_DIR=${fmt}"
    "-DSPDLOG_DIR=${spdlog.src}"
    "-DPIPER_PHONEMIZE_DIR=${piper-phonemize}"
  ];

  buildInputs = [
    onnxruntime
    pcaudiolib
    piper-phonemize
    piper-phonemize.espeak-ng
    spdlog
  ];

  env.NIX_CFLAGS_COMPILE = builtins.toString [
    "-isystem ${lib.getDev piper-phonemize}/include/piper-phonemize"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -m 0755 piper $out/bin

    runHook postInstall
  '';

  passthru.tests = {
    inherit piper-train;
  };

  meta = with lib; {
    changelog = "https://github.com/rhasspy/piper/releases/tag/v${finalAttrs.version}";
    description = "A fast, local neural text to speech system";
    homepage = "https://github.com/rhasspy/piper";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
    mainProgram = "piper";
  };
})
