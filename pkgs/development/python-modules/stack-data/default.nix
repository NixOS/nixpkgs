{
  asttokens,
  buildPythonPackage,
  cython,
  executing,
  fetchFromGitHub,
  lib,
  littleutils,
  pure-eval,
  pygments,
  pytestCheckHook,
  setuptools-scm,
  typeguard,
  setuptools,
  wheel,
}:

buildPythonPackage rec {
  pname = "stack-data";
  version = "0.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alexmojaki";
    repo = "stack_data";
    rev = "refs/tags/v${version}";
    hash = "sha256-dmBhfCg60KX3gWp3k1CGRxW14z3BLlair0PjLW9HFYo=";
  };

  build-system = [
    setuptools
    setuptools-scm
    wheel
  ];

  nativeCheckInputs = [
    cython
    littleutils
    pygments
    pytestCheckHook
    typeguard
  ];

  dependencies = [
    asttokens
    executing
    pure-eval
  ];

  disabledTests = [
    # AssertionError
    "test_example"
    "test_executing_style_defs"
    "test_pygments_example"
    "test_variables"
  ];

  pythonImportsCheck = [ "stack_data" ];

  meta = with lib; {
    description = "Extract data from stack frames and tracebacks";
    homepage = "https://github.com/alexmojaki/stack_data/";
    changelog = "https://github.com/alexmojaki/stack_data/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
    mainProgram = "stack-data";
  };
}
