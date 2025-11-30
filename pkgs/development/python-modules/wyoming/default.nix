{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # optional-dependencies
  flask,
  swagger-ui-py,
  zeroconf,

  # tests
  pytest-asyncio,
  pytestCheckHook,
  wyoming-faster-whisper,
  wyoming-openwakeword,
  wyoming-piper,
}:

buildPythonPackage rec {
  pname = "wyoming";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OHF-Voice";
    repo = "wyoming";
    tag = "v${version}";
    hash = "sha256-s1wYGqoTIsKj3u99/9KdKZmzUGzGeYq1TJHOkOVwkHQ=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    http = [
      flask
      swagger-ui-py
    ];
    zeroconf = [ zeroconf ];
  };

  pythonImportsCheck = [ "wyoming" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  passthru.tests = {
    inherit wyoming-faster-whisper wyoming-openwakeword wyoming-piper;
  };

  meta = with lib; {
    changelog = "https://github.com/OHF-Voice/wyoming/releases/tag/${src.tag}";
    description = "Protocol for Rhasspy Voice Assistant";
    homepage = "https://github.com/OHF-Voice/wyoming";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
