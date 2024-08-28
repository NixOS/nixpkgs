{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  behave,
  ruamel-yaml,
  schema,
  pytestCheckHook,
  pytest-mock,
}:

let
  version = "1.6.6";
in
buildPythonPackage {
  pname = "sismic";
  inherit version;
  pyproject = true;

  build-system = [ setuptools ];

  src = fetchFromGitHub {
    owner = "AlexandreDecan";
    repo = "sismic";
    rev = "refs/tags/${version}";
    hash = "sha256-MvJyyERH0l5547cVmpxnHXRf9q1ylK9/ZfyLYBQfsbY=";
  };

  pythonRelaxDeps = [ "behave" ];

  dependencies = [
    behave
    ruamel-yaml
    schema
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  pythonImportsCheck = [ "sismic" ];

  pytestFlagsArray = [ "tests/" ];

  disabledTests = [
    # Time related tests, might lead to flaky tests on slow/busy machines
    "test_clock"
  ];

  meta = {
    changelog = "https://github.com/AlexandreDecan/sismic/releases/tag/${version}";
    description = "Sismic Interactive Statechart Model Interpreter and Checker";
    homepage = "https://github.com/AlexandreDecan/sismic";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
