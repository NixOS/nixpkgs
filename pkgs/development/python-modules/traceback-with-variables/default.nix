{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pytest-cov
, ipython
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "traceback-with-variables";
  version = "2.0.4";
  format = "setuptools";
  disabled = pythonAtLeast "3.11";

  src = fetchFromGitHub {
    owner = "andy-landy";
    repo = "traceback_with_variables";
    rev = "v${version}";
    hash = "sha256-XxmWmGIwF+hd256XA8nWLxF5UTwZngL+0kQYfmsfYAA=";
  };

  patches = [
    ./01-fix-test-ouput.patch
  ];

  pythonImportsCheck = [ "traceback_with_variables" ];

  # warns about distutils removal in python 3.12
  # would modify executable output and thereby fail tests
  # can't use pytestFlagsArray as tests are a secondary command invokation
  PYTHONWARNINGS = "ignore::DeprecationWarning";

  nativeCheckInputs = [
    pytestCheckHook
    ipython
  ];

  meta = with lib; {
    description = "Adds local variables to python traceback";
    homepage = "https://github.com/andy-landy/traceback_with_variables";
    changelog = "https://github.com/andy-landy/traceback_with_variables/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ blaggacao ];
  };
}

