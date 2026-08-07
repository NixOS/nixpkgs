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
  version = "1.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OHF-Voice";
    repo = "wyoming";
    tag = "v${version}";
    hash = "sha256-bjte8CNqNYyEW0WeB8QTAsJJoXmZj/VQlt6ZbY2r5pI=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    http = [
      flask
      swagger-ui-py
    ]
    ++ flask.optional-dependencies.async;
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

  meta = {
    changelog = "https://github.com/OHF-Voice/wyoming/releases/tag/${src.tag}";
    description = "Protocol for Rhasspy Voice Assistant";
    homepage = "https://github.com/OHF-Voice/wyoming";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
}
