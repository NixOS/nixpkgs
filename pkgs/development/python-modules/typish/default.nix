{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pytestCheckHook,
  pythonAtLeast,
}:

buildPythonPackage rec {
  pname = "typish";
  version = "1.9.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ramonhagenaars";
    repo = "typish";
    tag = "v${version}";
    hash = "sha256-LnOg1dVs6lXgPTwRYg7uJ3LCdExYrCxS47UEJxKHhVU=";
  };

  # Tests fail on Python 3.14
  # TypeError: 'member_descriptor' object is not iterable
  disabled = pythonAtLeast "3.14";

  nativeCheckInputs = [
    numpy
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Requires a very old version of nptyping
    # which has a circular dependency on typish
    "tests/functions/test_instance_of.py"
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.11") [
    # https://github.com/ramonhagenaars/typish/issues/32
    "test_get_origin"
  ];

  pythonImportsCheck = [ "typish" ];

  meta = {
    description = "Python module for checking types of objects";
    homepage = "https://github.com/ramonhagenaars/typish";
    changelog = "https://github.com/ramonhagenaars/typish/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fmoda3 ];
  };
}
