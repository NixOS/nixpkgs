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
  version = "4.4.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pvEGWBPjLvNlvDs/UDr4qW+d1OADOgLCjEpJg96MbEk=";
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
  ]
  ++ lib.optionals (pythonOlder "3.10") [ importlib-metadata ];

  env.LC_ALL = "en_US.utf-8";

  nativeCheckInputs = [
    mypy
    pytestCheckHook
  ];

  pythonImportsCheck = [ "typeguard" ];

  meta = {
    description = "This library provides run-time type checking for functions defined with argument type annotations";
    homepage = "https://github.com/agronholm/typeguard";
    changelog = "https://github.com/agronholm/typeguard/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
