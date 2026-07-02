{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  typing-extensions,
  mypy,
  sphinxHook,
  sphinx-autodoc-typehints,
  sphinx-rtd-theme,
  glibcLocales,
}:

buildPythonPackage rec {
  pname = "typeguard";
  version = "4.5.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9vjsu8gZybx0mYPMZ8AjkeFqm0O4sn8V3HDtfEoAcnQ=";
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
  ];

  env.LC_ALL = "en_US.utf-8";

  nativeCheckInputs = [
    mypy
    pytestCheckHook
  ];

  # To prevent test from writing out non-reproducible .pyc files
  # https://github.com/agronholm/typeguard/blob/ca512c28132999da514f31b5e93ed2f294ca8f77/tests/test_typechecked.py#L641
  preCheck = "export PYTHONDONTWRITEBYTECODE=1";

  pythonImportsCheck = [ "typeguard" ];

  meta = {
    description = "This library provides run-time type checking for functions defined with argument type annotations";
    homepage = "https://github.com/agronholm/typeguard";
    changelog = "https://github.com/agronholm/typeguard/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
