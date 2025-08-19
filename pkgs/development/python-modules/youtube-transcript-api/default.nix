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
  version = "1.2.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jdepoix";
    repo = "youtube-transcript-api";
    tag = "v${version}";
    hash = "sha256-nr8WeegMv7zSqlzcLSG224O9fRXA6jIlYQN4vV6lW24=";
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

  disabledTests = [
    # fail with various assertions around numbers
    "test_fetch__create_consent_cookie_if_needed"
    "test_fetch__with_generic_proxy_reraise_when_blocked"
    "test_fetch__with_proxy_retry_when_blocked"
    "test_fetch__with_webshare_proxy_reraise_when_blocked"
    "test_version_matches_metadata"
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
