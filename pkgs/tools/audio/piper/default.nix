{ lib
, stdenv
, fetchFromGitHub

# build time
, cmake
, pkg-config

# runtime
, onnxruntime
, pcaudiolib
, piper-phonemize
, spdlog

# tests
, piper-train
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "piper";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "piper";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-6WNWqJt0PO86vnf+3iHaRRg2KwBOEj4aicmB+P2phlk=";
  };

  sourceRoot = "${finalAttrs.src.name}/src/cpp";

  nativeBuildInputs = [
    cmake
    pkg-config
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
  };
})
