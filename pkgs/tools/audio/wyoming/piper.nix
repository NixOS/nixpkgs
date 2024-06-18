{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "wyoming-piper";
  version = "1.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "wyoming-piper";
    rev = "v${version}";
    hash = "sha256-aI1CWtSpSPX1aK4UR/lsCQZQwNs7qOLKfatlSomJx1Q=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "wyoming"
  ];

  propagatedBuildInputs = with python3Packages; [
    wyoming
  ];

  pythonImportsCheck = [
    "wyoming_piper"
  ];

  doCheck = false;

  meta = with lib; {
    changelog = "https://github.com/rhasspy/wyoming-openwakeword/v${version}/master/CHANGELOG.md";
    description = "Wyoming Server for Piper";
    mainProgram = "wyoming-piper";
    homepage = "https://github.com/rhasspy/wyoming-openwakeword";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
