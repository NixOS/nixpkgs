{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cacert,
  cohere,
  faster-whisper,
  flac,
  google-cloud-speech,
  groq,
  httpx,
  openai-whisper,
  openai,
  pocketsphinx,
  pyaudio,
  pytest-httpserver,
  pytestCheckHook,
  requests,
  respx,
  setuptools,
  soundfile,
  standard-aifc,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "speechrecognition";
  version = "3.16.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Uberi";
    repo = "speech_recognition";
    tag = finalAttrs.version;
    hash = "sha256-EIDhWx1s1B0DX4Vmd/a8hRnTBgdBx9ALOonOWFPgUOg=";
  };

  postPatch = ''
    # Remove Bundled binaries
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
    pytest-httpserver
    pytestCheckHook
    pocketsphinx
    respx
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "speech_recognition" ];

  disabledTests = [
    # Parsed string does not match expected
    "test_sphinx_keywords"
  ];

  disabledTestPaths = [
    # vosk is not available in nixpkgs
    "tests/recognizers/test_vosk.py"
  ];

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
