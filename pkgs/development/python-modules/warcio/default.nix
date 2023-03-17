{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, six
, setuptools
, pytestCheckHook
, httpbin
, requests
, wsgiprox
, multidict
}:

buildPythonPackage rec {
  pname = "warcio";
  version = "1.7.4";

  src = fetchFromGitHub {
    owner = "webrecorder";
    repo = "warcio";
    rev = "aa702cb321621b233c6e5d2a4780151282a778be"; # Repo has no git tags, see https://github.com/webrecorder/warcio/issues/126
    sha256 = "sha256-wn2rd73wRfOqHu9H0GIn76tmEsERBBCQatnk4b/JToU=";
  };

  patches = [
    (fetchpatch {
      name = "add-offline-option.patch";
      url = "https://github.com/webrecorder/warcio/pull/135/commits/2546fe457c57ab0b391764a4ce419656458d9d07.patch";
      sha256 = "sha256-3izm9LvAeOFixiIUUqmd5flZIxH92+NxL7jeu35aObQ=";
    })
  ];

  propagatedBuildInputs = [
    six
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
    httpbin
    requests
    wsgiprox
    multidict # Optional. Without this, one test in test/test_utils.py is skipped.
  ];

  pytestFlagsArray = [ "--offline" ];

  pythonImportsCheck = [ "warcio" ];

  meta = with lib; {
    description = "Streaming WARC/ARC library for fast web archive IO";
    homepage = "https://github.com/webrecorder/warcio";
    license = licenses.asl20;
    maintainers = with maintainers; [ Luflosi ];
  };
}
