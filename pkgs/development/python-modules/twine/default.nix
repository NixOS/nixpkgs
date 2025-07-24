{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  id,
  importlib-metadata,
  keyring,
  packaging,
  pkginfo,
  readme-renderer,
  requests,
  requests-toolbelt,
  rich,
  rfc3986,
  setuptools,
  setuptools-scm,
  urllib3,
  build,
  pretend,
  pytest-socket,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "twine";
  version = "6.1.0";
  pyproject = true;
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vjJPYnLv+R0H7pPyUe3yMvxkeTXdWFrAA1ObQkBKjb0=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    id
    keyring
    packaging
    pkginfo
    readme-renderer
    requests
    requests-toolbelt
    rfc3986
    rich
    urllib3
  ]
  ++ lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ];

  nativeCheckInputs = [
    build
    pretend
    pytest-socket
    pytestCheckHook
  ];

  pythonImportsCheck = [ "twine" ];

  meta = {
    description = "Collection of utilities for interacting with PyPI";
    mainProgram = "twine";
    homepage = "https://github.com/pypa/twine";
    license = lib.licenses.asl20;
  };
}
