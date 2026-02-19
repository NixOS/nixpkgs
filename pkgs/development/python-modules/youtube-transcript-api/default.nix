{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  defusedxml,
  requests,
  httpretty,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "youtube-transcript-api";
  version = "1.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jdepoix";
    repo = "youtube-transcript-api";
    tag = "v${version}";
    hash = "sha256-FFLbDiZJR+xqaMMjcBQFYgrdJEofTiBdSNmmlMlrNfY=";
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

  preCheck = ''
    export PATH=$out/bin:$PATH
  '';

  disabledTests = [
    # network access
    "test_fetch__create_consent_cookie_if_needed"
    "test_fetch__with_generic_proxy_reraise_when_blocked"
    "test_fetch__with_proxy_retry_when_blocked"
    "test_fetch__with_webshare_proxy_reraise_when_blocked"
  ];

  pythonImportsCheck = [ "youtube_transcript_api" ];

  meta = {
    description = "Python API which allows you to get the transcripts/subtitles for a given YouTube video";
    mainProgram = "youtube_transcript_api";
    homepage = "https://github.com/jdepoix/youtube-transcript-api";
    changelog = "https://github.com/jdepoix/youtube-transcript-api/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
