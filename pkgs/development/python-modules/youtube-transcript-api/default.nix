{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, mock
, httpretty
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "youtube-transcript-api";
<<<<<<< HEAD
  version = "0.6.1";
=======
  version = "0.6.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jdepoix";
    repo = pname;
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-7s2qzmfYkaQ7xAi/U+skOEVTAj2gp+2WnODu9k1ojJY=";
=======
    hash = "sha256-TJlyWO1knP07gHVgbz1K0pBtvkTYrNJWZsassllko+I=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    requests
  ];

  nativeCheckInputs = [
    mock
    httpretty
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "youtube_transcript_api"
  ];

  meta = with lib; {
    description = "Python API which allows you to get the transcripts/subtitles for a given YouTube video";
    homepage = "https://github.com/jdepoix/youtube-transcript-api";
<<<<<<< HEAD
    changelog = "https://github.com/jdepoix/youtube-transcript-api/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
