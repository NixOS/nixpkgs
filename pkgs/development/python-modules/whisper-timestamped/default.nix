{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  cython,
  dtw-python,
  openai-whisper,

  # optional-dependencies
  auditok,
  onnxruntime,
  torchaudio,
}:

buildPythonPackage (finalAttrs: {
  pname = "whisper-timestamped";
  version = "1.15.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "linto-ai";
    repo = "whisper-timestamped";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oB835viMRl79SfzxkSuxRVFYv0zwHLeDtykj2HdphYw=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    cython
    dtw-python
    openai-whisper
  ];

  optional-dependencies = {
    vad-auditok = [
      auditok
    ];
    vad-silero = [
      onnxruntime
      torchaudio
    ];
  };

  pythonImportsCheck = [ "whisper_timestamped" ];

  # tests require model downloads
  doCheck = false;

  meta = {
    description = "Multilingual automatic speech recognition with word-level timestamps";
    homepage = "https://github.com/linto-ai/whisper-timestamped";
    changelog = "https://github.com/linto-ai/whisper-timestamped/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    mainProgram = "whisper_timestamped";
    maintainers = with lib.maintainers; [ seirl ];
  };
})
