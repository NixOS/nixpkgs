{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  defusedxml,
  requests,
  httpretty,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "youtube-transcript-api";
  version = "1.0.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jdepoix";
    repo = "youtube-transcript-api";
    tag = "v${version}";
    hash = "sha256-MDa19rI5DaIzrrEt7uNQ5+xSFkRXI5iwt/u5UNvT1f4=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [
    "defusedxml"
  ];

  dependencies = [
    defusedxml
    requests
  ];

  nativeCheckInputs = [
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
