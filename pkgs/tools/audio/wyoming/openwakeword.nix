{ lib
, python3Packages
, fetchFromGitHub
}:

python3Packages.buildPythonApplication rec {
  pname = "wyoming-openwakeword";
  version = "1.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "wyoming-openwakeword";
    rev = "refs/tags/v${version}";
    hash = "sha256-5suYJ+Z6ofVAysoCdHi5b5K0JTYaqeFZ32Cm76wC5LU=";
  };

  nativeBuildInputs = with python3Packages; [
    setuptools
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "wyoming"
  ];

  pythonRemoveDeps = [
    "tflite-runtime-nightly"
  ];

  propagatedBuildInputs = with python3Packages; [
    tensorflow
    wyoming
  ];

  pythonImportsCheck = [
    "wyoming_openwakeword"
  ];

  meta = with lib; {
    changelog = "https://github.com/rhasspy/wyoming-openwakeword/blob/v${version}/CHANGELOG.md";
    description = "An open source voice assistant toolkit for many human languages";
    homepage = "https://github.com/rhasspy/wyoming-openwakeword";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
    mainProgram = "wyoming-openwakeword";
  };
}
