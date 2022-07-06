{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "circup";
  version = "1.1.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "adafruit";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-zrpld0yexzoXJx4qqDPEMf58SN67SGoP3umNqqsFJgw=";
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
    "circup"
  ];

  meta = with lib; {
    description = "CircuitPython library updater";
    homepage = "https://github.com/adafruit/circup";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
