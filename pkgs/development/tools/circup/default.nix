{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "circup";
  version = "1.0.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "adafruit";
    repo = pname;
    rev = version;
    hash = "sha256-qX3kSlqA2qP8+XiLYx/hKYfyeB6p3tnXEhESox0c/lY=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = with python3.pkgs; [
    setuptools-scm
  ];

  propagatedBuildInputs = with python3.pkgs; [
    appdirs
    click
    findimports
    requests
    semver
    setuptools
    update_checker
  ];

  checkInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  postBuild = ''
    export HOME=$(mktemp -d);
  '';

  pythonImportsCheck = [
    " circup "
  ];

  meta = with lib; {
    description = "CircuitPython library updater";
    homepage = "https://github.com/adafruit/circup";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
