{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pytestCheckHook,
  pythonOlder,
  torch,
  requests,
  setuptools,
  openai,
  pyaudio,
  soundfile,
  openai-whisper,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "speechrecognition";
  version = "3.11.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Uberi";
    repo = "speech_recognition";
    rev = "refs/tags/${version}";
    hash = "sha256-5DZ5QhaYpVtd+AX5OSYD3cM+37Ez0+EL5a+zJ+X/uNg=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    typing-extensions
  ];

  optional-dependencies = {
    audio = [ pyaudio ];
    whisper-local = [
      openai-whisper
      soundfile
    ];
    whisper-api = [ openai ];
  };

  nativeCheckInputs = [
    numpy
    pytestCheckHook
    torch
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "speech_recognition" ];

  disabledTests = [
    # Test files are missing in source
    "test_flac"
    # Attribute error
    "test_whisper"
    # PocketSphinx is not available in Nixpkgs
    "test_sphinx"
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
