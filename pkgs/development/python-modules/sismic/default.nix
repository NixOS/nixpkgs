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
  version = "1.6.11";
in
buildPythonPackage (finalAttrs: {
  pname = "sismic";
  inherit version;
  pyproject = true;

  build-system = [ setuptools ];

  src = fetchFromGitHub {
    owner = "AlexandreDecan";
    repo = "sismic";
    tag = finalAttrs.version;
    hash = "sha256-MD8SN3xPY1YtonogVasZZoHLADm1GU5AARSFY7ZwVPU=";
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

  enabledTestPaths = [ "tests/" ];

  disabledTests = [
    # Time related tests, might lead to flaky tests on slow/busy machines
    "test_clock"
  ];

  meta = {
    changelog = "https://github.com/AlexandreDecan/sismic/releases/tag/${finalAttrs.src.tag}";
    description = "Sismic Interactive Statechart Model Interpreter and Checker";
    homepage = "https://github.com/AlexandreDecan/sismic";
    license = lib.licenses.lgpl3Only;
    maintainers = [ ];
  };
})
