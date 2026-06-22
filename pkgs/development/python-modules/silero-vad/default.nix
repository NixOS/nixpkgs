{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  packaging,
  torch,
  torchaudio,
}:
buildPythonPackage (finalAttrs: {
  pname = "silero-vad";
  version = "6.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "snakers4";
    repo = "silero-vad";
    tag = "v${finalAttrs.version}";
    hash = "sha256-peGaJkSqjeobgx479OKt8ErorFviTIA7naFPewgab4U=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    packaging
    torch
    torchaudio
  ];

  # tests use torchcodec which refuses to decode tests/data/test.mp3
  # this causes all tests to fail. See https://github.com/snakers4/silero-vad/issues/777
  doCheck = false;

  pythonImportsCheck = [
    "silero_vad"
  ];

  meta = {
    description = "Silero VAD: pre-trained enterprise-grade Voice Activity Detector";
    changelog = "https://github.com/snakers4/silero-vad/releases/tag/${finalAttrs.src.tag}";
    homepage = "https://github.com/snakers4/silero-vad";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ seudonym ];
  };
})
