{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cacert,
  faster-whisper,
  flac,
  google-cloud-speech,
  groq,
  httpx,
  openai-whisper,
  openai,
  pocketsphinx,
  pyaudio,
  pytestCheckHook,
  pythonOlder,
  requests,
  respx,
  setuptools,
  soundfile,
  standard-aifc,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "speechrecognition";
  version = "3.14.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Uberi";
    repo = "speech_recognition";
    tag = version;
    hash = "sha256-g//KKxPRe1pWVJo7GsRNIV59r0J7XJEoXvH0tGuV3Jk=";
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
  };

  nativeCheckInputs = [
    groq
    pytestCheckHook
    pocketsphinx
    respx
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "speech_recognition" ];

  disabledTests = [
    # Parsed string does not match expected
    "test_sphinx_keywords"
  ];

  meta = with lib; {
    description = "Speech recognition module for Python, supporting several engines and APIs, online and offline";
    homepage = "https://github.com/Uberi/speech_recognition";
    changelog = "https://github.com/Uberi/speech_recognition/releases/tag/${src.tag}";
    license = with licenses; [
      gpl2Only
      bsd3
    ];
    maintainers = with maintainers; [ fab ];
  };
}
