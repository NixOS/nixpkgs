{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  six,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ush";
  version = "4.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tarruda";
    repo = "python-ush";
    rev = version;
    hash = "sha256-a6ICbd8647DRtuHl2vs64bsChUjlpuWHV1ipBdFA600=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "ush" ];

  nativeCheckInputs = [
    pytestCheckHook
    six
  ];

  disabledTestPaths = [
    # seems to be outdated?
    "tests/test_glob.py"
  ];

  meta = with lib; {
    description = "Powerful API for invoking with external commands";
    homepage = "https://github.com/tarruda/python-ush";
    license = licenses.mit;
    maintainers = [ ];
  };
}
