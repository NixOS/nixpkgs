{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # optional-dependencies
  zeroconf,

  # tests
  wyoming-faster-whisper,
  wyoming-openwakeword,
  wyoming-piper,
}:

buildPythonPackage rec {
  pname = "wyoming";
  version = "1.5.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "wyoming";
    rev = "refs/tags/${version}";
    hash = "sha256-SOPkvFMjoDQiWVP39+1Cx4fFmPH8wcBhZhaKapdZaeA=";
  };

  nativeBuildInputs = [ setuptools ];

  passthru.optional-dependencies = {
    zeroconf = [ zeroconf ];
  };

  pythonImportsCheck = [ "wyoming" ];

  # no tests
  doCheck = false;

  passthru.tests = {
    inherit wyoming-faster-whisper wyoming-openwakeword wyoming-piper;
  };

  meta = with lib; {
    changelog = "https://github.com/rhasspy/wyoming/releases/tag/${version}";
    description = "Protocol for Rhasspy Voice Assistant";
    homepage = "https://github.com/rhasspy/wyoming";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
