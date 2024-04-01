{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pytestCheckHook
, pythonOlder
, torch
, requests
, setuptools
, soundfile
, typing-extensions
}:

buildPythonPackage rec {
  pname = "speechrecognition";
  version = "3.10.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Uberi";
    repo = "speech_recognition";
    rev = "refs/tags/${version}";
    hash = "sha256-g2DE3u2nuJHqWA2X8S6zw5nUVS1yvSqO0VI3zKoIUgg=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    requests
    typing-extensions
  ];

  nativeCheckInputs = [
    numpy
    pytestCheckHook
    torch
    soundfile
  ];

  pythonImportsCheck = [
    "speech_recognition"
  ];

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
    license = with licenses; [ gpl2Only bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
