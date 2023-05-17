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
  version = "0.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jdepoix";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-TJlyWO1knP07gHVgbz1K0pBtvkTYrNJWZsassllko+I=";
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
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
