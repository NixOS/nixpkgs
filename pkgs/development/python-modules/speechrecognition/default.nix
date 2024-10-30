{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flac,
  openai,
  openai-whisper,
  pocketsphinx,
  pyaudio,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
  soundfile,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "speechrecognition";
  version = "3.10.4";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Uberi";
    repo = "speech_recognition";
    rev = "refs/tags/${version}";
    hash = "sha256-icXZUg2lVLo8Z5t9ptDj67BjQLnEgrG8geYZ/lZeJt4=";
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
    pyaudio
    requests
    typing-extensions
  ];

  optional-dependencies = {
    whisper-api = [ openai ];
    whisper-local = [
      openai-whisper
      soundfile
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pocketsphinx
  ] ++ optional-dependencies.whisper-local ++ optional-dependencies.whisper-api;

  pythonImportsCheck = [ "speech_recognition" ];

  disabledTests = [
    # Parsed string does not match expected
    "test_sphinx_keywords"
  ];

  meta = with lib; {
    description = "Speech recognition module for Python, supporting several engines and APIs, online and offline";
    homepage = "https://github.com/Uberi/speech_recognition";
    changelog = "https://github.com/Uberi/speech_recognition/releases/tag/${version}";
    license = with licenses; [
      gpl2Only
      bsd3
    ];
    maintainers = with maintainers; [ fab ];
  };
}
