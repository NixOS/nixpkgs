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
  version = "1.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "wyoming";
    tag = version;
    hash = "sha256-Q7e4YSvVHpjyJQwsXTfyzMA1DKi71xiVDKWGWTh1l6w=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    zeroconf = [ zeroconf ];
  };

  pythonImportsCheck = [ "wyoming" ];

  # no tests
  doCheck = false;

  passthru.tests = {
    inherit wyoming-faster-whisper wyoming-openwakeword wyoming-piper;
  };

  meta = with lib; {
    changelog = "https://github.com/rhasspy/wyoming/releases/tag/${src.tag}";
    description = "Protocol for Rhasspy Voice Assistant";
    homepage = "https://github.com/rhasspy/wyoming";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
