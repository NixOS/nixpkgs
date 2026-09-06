{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  flac,

  # build-system
  setuptools,

  # dependencies
  standard-aifc,
  typing-extensions,

  # optional-dependencies
  # assemblyai
  requests,
  # audio
  pyaudio,
  # cohere
  cohere,
  # faster-whisper
  faster-whisper,
  # google-cloud
  google-cloud-speech,
  # grok
  groq,
  httpx,
  # openai
  openai,
  # pocketsphinx
  pocketsphinx,
  # whisper-local
  openai-whisper,
  soundfile,

  # tests
  pytest-httpserver,
  pytestCheckHook,
  respx,
}:

buildPythonPackage (finalAttrs: {
  pname = "speechrecognition";
  version = "3.17.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Uberi";
    repo = "speech_recognition";
    tag = finalAttrs.version;
    hash = "sha256-rzCBOQ0dIfreMRDHMSgMYspJ5KyOSxN18B3mf+n9v2w=";
  };

  # Remove Bundled binaries
  postPatch = ''
    rm speech_recognition/flac-*
    rm -r third-party

    substituteInPlace speech_recognition/audio.py \
      --replace-fail 'shutil_which("flac")' '"${lib.getExe flac}"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    standard-aifc
    typing-extensions
  ];

  optional-dependencies = {
    assemblyai = [ requests ];
    audio = [ pyaudio ];
    cohere = [ cohere ];
    faster-whisper = [ faster-whisper ];
    google-cloud = [ google-cloud-speech ];
    groq = [
      groq
      httpx
    ];
    openai = [
      httpx
      openai
    ];
    pocketsphinx = [ pocketsphinx ];
    whisper-local = [
      openai-whisper
      soundfile
    ];
    # vosk = [ vosk ];
  };

  nativeCheckInputs = [
    groq
    pocketsphinx
    pytest-httpserver
    pytestCheckHook
    respx
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [ "speech_recognition" ];

  disabledTests = [
    # Parsed string does not match expected
    "test_sphinx_keywords"
  ];

  disabledTestPaths = [
    # vosk is not available in nixpkgs
    "tests/recognizers/test_vosk.py"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Speech recognition module for Python, supporting several engines and APIs, online and offline";
    homepage = "https://github.com/Uberi/speech_recognition";
    changelog = "https://github.com/Uberi/speech_recognition/releases/tag/${finalAttrs.src.tag}";
    license = with lib.licenses; [
      gpl2Only
      bsd3
    ];
    maintainers = with lib.maintainers; [ fab ];
  };
})
