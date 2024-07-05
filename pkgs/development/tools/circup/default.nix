{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "circup";
  version = "1.4.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "adafruit";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-kax4gnvRkHSqj0Y6Rk8eyPpT7Wia2QngCQtxpqWSl9s=";
  };

  pythonRelaxDeps = [
    "semver"
  ];

  nativeBuildInputs = with python3.pkgs; [
    setuptools-scm
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    click
    findimports
    requests
    semver
    setuptools
    update-checker
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  postBuild = ''
    export HOME=$(mktemp -d);
  '';

  pythonImportsCheck = [
    "circup"
  ];

  meta = with lib; {
    description = "CircuitPython library updater";
    mainProgram = "circup";
    homepage = "https://github.com/adafruit/circup";
    changelog = "https://github.com/adafruit/circup/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
