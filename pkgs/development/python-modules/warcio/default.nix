{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  httpbin,
  multidict,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
  six,
  wsgiprox,
}:

buildPythonPackage rec {
  pname = "warcio";
  version = "1.7.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "webrecorder";
    repo = "warcio";
    rev = "aa702cb321621b233c6e5d2a4780151282a778be"; # Repo has no git tags, see https://github.com/webrecorder/warcio/issues/126
    hash = "sha256-wn2rd73wRfOqHu9H0GIn76tmEsERBBCQatnk4b/JToU=";
  };

  patches = [
    (fetchpatch {
      # Add offline mode to skip tests that require an internet connection, https://github.com/webrecorder/warcio/pull/135
      name = "add-offline-option.patch";
      url = "https://github.com/webrecorder/warcio/pull/135/commits/2546fe457c57ab0b391764a4ce419656458d9d07.patch";
      hash = "sha256-3izm9LvAeOFixiIUUqmd5flZIxH92+NxL7jeu35aObQ=";
    })
  ];

  propagatedBuildInputs = [
    six
    setuptools
  ];

  nativeCheckInputs = [
    httpbin
    multidict # Optional. Without this, one test in test/test_utils.py is skipped.
    pytestCheckHook
    requests
    wsgiprox
  ];

  pytestFlagsArray = [ "--offline" ];

  disabledTests = [
    # Tests require network access, see above
    "test_get_cache_to_file"
  ];

  pythonImportsCheck = [ "warcio" ];

  meta = with lib; {
    description = "Streaming WARC/ARC library for fast web archive IO";
    mainProgram = "warcio";
    homepage = "https://github.com/webrecorder/warcio";
    changelog = "https://github.com/webrecorder/warcio/blob/master/CHANGELIST.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ Luflosi ];
  };
}
