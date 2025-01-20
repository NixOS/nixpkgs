{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  mock,
  httpretty,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "youtube-transcript-api";
  version = "0.6.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jdepoix";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-ZoF9BOQLrq2GVCZ98I8C9qouUhwZKEPp0zlTAqyEoYk=";
  };

  propagatedBuildInputs = [ requests ];

  nativeCheckInputs = [
    mock
    httpretty
    pytestCheckHook
  ];

  pythonImportsCheck = [ "youtube_transcript_api" ];

  meta = with lib; {
    description = "Python API which allows you to get the transcripts/subtitles for a given YouTube video";
    mainProgram = "youtube_transcript_api";
    homepage = "https://github.com/jdepoix/youtube-transcript-api";
    changelog = "https://github.com/jdepoix/youtube-transcript-api/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
