{ lib, buildPythonPackage, fetchFromGitHub, requests, mock, httpretty, pytestCheckHook }:

buildPythonPackage rec {
  pname = "youtube-transcript-api";
  version = "0.4.4";

  # PyPI tarball is missing some test files
  src = fetchFromGitHub {
    owner = "jdepoix";
    repo = "youtube-transcript-api";
    rev = "v${version}";
    sha256 = "sha256-RNPWTgAOwS+tXGLQYyIyka36xS1E1499OAP84aT6m3A=";
  };

  propagatedBuildInputs = [ requests ];

  checkInputs = [ mock httpretty pytestCheckHook ];

  pythonImportsCheck = [ "youtube_transcript_api" ];

  meta = with lib; {
    description = "Python API which allows you to get the transcripts/subtitles for a given YouTube video";
    homepage = "https://github.com/jdepoix/youtube-transcript-api";
    license = licenses.mit;
    maintainers = [ maintainers.marsam ];
  };
}
