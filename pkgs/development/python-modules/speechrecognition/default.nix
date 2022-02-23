{ lib
, buildPythonPackage
, fetchFromGitHub
, substituteAll

# runtime
, flac
, pocketsphinx
, pyaudio

# tests
, pytestCheckHook
}:

let
  pname = "speechrecognition";
  version = "3.8.1";
in
buildPythonPackage {
  inherit pname version;
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Uberi";
    repo = "speech_recognition";
    rev = version;
    hash = "sha256:5OsffPcP95+WBI2qWO41fZDj+5mRmzUgIyv4QSd5BtM=";
  };

  patches = [
    (substituteAll {
      src = ./flac-path.patch;
      flac = "${flac}/bin/flac";
    })
  ];

  propagatedBuildInputs = [
    pocketsphinx
    pyaudio
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Requires network access
    "test_google_chinese"
    "test_google_english"
    "test_google_french "
    "test_sphinx_english"
    # AssertionError: 'three  two  two  one  one ' != 'three  two  two  one '
    "test_sphinx_keywords"
  ];

  pythonImportsCheck = [
    "speech_recognition"
  ];

  meta = with lib; {
    description = "Speech recognition module for Python, supporting several engines and APIs, online and offline";
    homepage = "https://github.com/Uberi/speech_recognition";
    license = licenses.bsd3;
    maintainers = teams.mycroft.members;
  };
}
