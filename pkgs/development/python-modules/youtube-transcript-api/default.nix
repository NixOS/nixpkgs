{ lib, buildPythonPackage, fetchFromGitHub, requests, mock, httpretty, pytestCheckHook }:

buildPythonPackage rec {
  pname = "youtube-transcript-api";
  version = "0.4.2";

  # PyPI tarball is missing some test files
  src = fetchFromGitHub {
    owner = "jdepoix";
    repo = "youtube-transcript-api";
    rev = "v${version}";
    sha256 = "04x7mfp4q17w3n8dnklbxblz22496g7g4879nz0wzgijg3m6cwlp";
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
