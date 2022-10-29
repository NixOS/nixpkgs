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
  version = "0.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jdepoix";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-oTKvJt6tyv/ESJ5+Io8M8/KnuW4hN2P7w14sldsKwzw=";
  };

  propagatedBuildInputs = [
    requests
  ];

  checkInputs = [
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
