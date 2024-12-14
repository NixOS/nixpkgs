{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  typing-extensions,
  importlib-metadata,
  mypy,
  sphinxHook,
  sphinx-autodoc-typehints,
  sphinx-rtd-theme,
  glibcLocales,
}:

buildPythonPackage rec {
  pname = "typeguard";
  version = "4.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ku5qCuyRNRgermBn69YX/Z3o111xT7VIcopJM7HeplE=";
  };

  outputs = [
    "out"
    "doc"
  ];

  build-system = [
    glibcLocales
    setuptools
    setuptools-scm
    sphinxHook
    sphinx-autodoc-typehints
    sphinx-rtd-theme
  ];

  dependencies = [
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.10") [ importlib-metadata ];

  env.LC_ALL = "en_US.utf-8";

  nativeCheckInputs = [
    mypy
    pytestCheckHook
  ];

  pythonImportsCheck = [ "typeguard" ];

  disabledTestPaths = [
    # mypy tests aren't passing with latest mypy
    "tests/mypy"
  ];

  disabledTests = [
    # AssertionError: 'type of argument "x" must be ' != 'None'
    "TestPrecondition::test_precondition_ok_and_typeguard_fails"
    # AttributeError: 'C' object has no attribute 'x'
    "TestInvariant::test_invariant_ok_and_typeguard_fails"
    # AttributeError: 'D' object has no attribute 'x'
    "TestInheritance::test_invariant_ok_and_typeguard_fails"
  ];

  meta = with lib; {
    description = "This library provides run-time type checking for functions defined with argument type annotations";
    homepage = "https://github.com/agronholm/typeguard";
    changelog = "https://github.com/agronholm/typeguard/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
