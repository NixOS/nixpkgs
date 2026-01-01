{
  lib,
  buildPythonPackage,
<<<<<<< HEAD
  fetchFromGitHub,
  pythonAtLeast,
=======
  fetchPypi,
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
<<<<<<< HEAD
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ipython";
    repo = "traitlets";
    tag = "v${version}";
    hash = "sha256-lWtgzXW1ffzl1jkFaq99X0dU8agulUMHaghsYKX+8Dk=";
  };

  build-system = [ hatchling ];
=======
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ntBXnTUCyUtLNzKsEgN1zalvkjEUUihH3ks7uYuWtrc=";
  };

  nativeBuildInputs = [ hatchling ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  nativeCheckInputs = [
    argcomplete
    pytest-mock
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/ipython/traitlets/issues/902
    "test_complete_custom_completers"
<<<<<<< HEAD
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # https://github.com/ipython/traitlets/issues/925
    "test_complete_simple_app"
    "test_complete_subcommands_subapp1"
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
