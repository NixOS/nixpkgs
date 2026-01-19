{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "verboselogs";
  version = "1.7";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "xolox";
    repo = "python-verboselogs";
    rev = version;
    hash = "sha256-hcIdbn0gdkdJ33KcOx6uv0iMXW0x+i880SoROi+qX4I=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  pythonImportsCheck = [ "verboselogs" ];

  disabledTests = [
    # Do not run pylint plugin test
    "test_pylint_plugin"
  ];

  meta = {
    description = "Verbose logging for Python's logging module";
    homepage = "https://github.com/xolox/python-verboselogs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ eyjhb ];
  };
}
