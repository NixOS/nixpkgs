{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools

# optional-dependencies
, zeroconf

# tests
, wyoming-faster-whisper
, wyoming-openwakeword
, wyoming-piper
}:

buildPythonPackage rec {
  pname = "wyoming";
  version = "1.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "wyoming";
    rev = "refs/tags/${version}";
    hash = "sha256-uMUx+fEjNg4yGJE4NQOjM5kP4LM1LHIhNfAR1ohzCpg=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  passthru.optional-dependencies = {
    zeroconf = [
      zeroconf
    ];
  };

  pythonImportsCheck = [
    "wyoming"
  ];

  # no tests
  doCheck = false;

  passthru.tests = {
    inherit
      wyoming-faster-whisper
      wyoming-openwakeword
      wyoming-piper
    ;
  };

  meta = with lib; {
    changelog = "https://github.com/rhasspy/wyoming/releases/tag/${version}";
    description = "Protocol for Rhasspy Voice Assistant";
    homepage = "https://github.com/rhasspy/wyoming";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
