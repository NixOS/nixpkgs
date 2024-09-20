{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "wyoming-faster-whisper";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "wyoming-faster-whisper";
    rev = "refs/tags/v${version}";
    hash = "sha256-zWa872YkPh8B7dE//leth+ixIa1wHSRcjkvH2lXzolc=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
  ];

  pythonRelaxDeps = [
    "faster-whisper"
    "wyoming"
  ];

  propagatedBuildInputs = with python3Packages; [
    faster-whisper
    wyoming
  ];

  pythonImportsCheck = [
    "wyoming_faster_whisper"
  ];

  # no tests
  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/rhasspy/wyoming-faster-whisper/releases/tag/v${version}";
    description = "Wyoming Server for Faster Whisper";
    homepage = "https://github.com/rhasspy/wyoming-faster-whisper";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
