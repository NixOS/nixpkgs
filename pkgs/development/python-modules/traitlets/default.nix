{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # build-system
  hatchling,

  # tests
  argcomplete,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "traitlets";
  version = "5.14.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ntBXnTUCyUtLNzKsEgN1zalvkjEUUihH3ks7uYuWtrc=";
  };

  nativeBuildInputs = [ hatchling ];

  nativeCheckInputs = [
    argcomplete
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/ipython/traitlets/issues/902
    "test_complete_custom_completers"
  ];

  disabledTestPaths = [
    # requires mypy-testing
    "tests/test_typing.py"
  ];

  meta = {
    changelog = "https://github.com/ipython/traitlets/blob/v${version}/CHANGELOG.md";
    description = "Traitlets Python config system";
    homepage = "https://github.com/ipython/traitlets";
    license = lib.licenses.bsd3;
  };
}
