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
  version = "0.6.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jdepoix";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-xCB1XhXRq4jxyfst/n2wXj2k4dERm+/bVUJwP8b70gQ=";
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
    changelog = "https://github.com/jdepoix/youtube-transcript-api/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
