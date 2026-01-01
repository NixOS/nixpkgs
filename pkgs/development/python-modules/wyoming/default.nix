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
<<<<<<< HEAD
    ]
    ++ flask.optional-dependencies.async;
=======
    ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    zeroconf = [ zeroconf ];
  };

  pythonImportsCheck = [ "wyoming" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ]
<<<<<<< HEAD
  ++ lib.concatAttrValues optional-dependencies;
=======
  ++ lib.flatten (lib.attrValues optional-dependencies);
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  passthru.tests = {
    inherit wyoming-faster-whisper wyoming-openwakeword wyoming-piper;
  };

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/OHF-Voice/wyoming/releases/tag/${src.tag}";
    description = "Protocol for Rhasspy Voice Assistant";
    homepage = "https://github.com/OHF-Voice/wyoming";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
=======
  meta = with lib; {
    changelog = "https://github.com/OHF-Voice/wyoming/releases/tag/${src.tag}";
    description = "Protocol for Rhasspy Voice Assistant";
    homepage = "https://github.com/OHF-Voice/wyoming";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
