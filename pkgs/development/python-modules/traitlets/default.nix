{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  hatchling,

  # tests
  argcomplete,
  pytest-mock,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "traitlets";
  version = "5.15.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ipython";
    repo = "traitlets";
    tag = "v${version}";
    hash = "sha256-c4OZSC2MrX6Jx8x49lOzlkgwpwz+/2l+GGVCzpO/P+8=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [
    argcomplete
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/ipython/traitlets/issues/902
    "test_complete_custom_completers"
    # https://github.com/ipython/traitlets/issues/925
    "test_complete_simple_app"
    "test_complete_subcommands_subapp1"
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
