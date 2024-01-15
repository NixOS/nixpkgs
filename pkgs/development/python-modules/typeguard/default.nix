{ buildPythonPackage
, fetchPypi
, pythonOlder
, lib
, setuptools
, setuptools-scm
, pytestCheckHook
, typing-extensions
, importlib-metadata
, sphinxHook
, sphinx-autodoc-typehints
, sphinx-rtd-theme
, glibcLocales
}:

buildPythonPackage rec {
  pname = "typeguard";
  version = "4.1.5";
  format = "pyproject";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-6goRO7wRG8/8kHieuyFWJcljQR9wlqfpBi1ORjDBVf0=";
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    glibcLocales
    setuptools
    setuptools-scm
    sphinxHook
    sphinx-autodoc-typehints
    sphinx-rtd-theme
  ];

  propagatedBuildInputs = [
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ];

  env.LC_ALL = "en_US.utf-8";

  nativeCheckInputs = [
    pytestCheckHook
  ];

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
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
