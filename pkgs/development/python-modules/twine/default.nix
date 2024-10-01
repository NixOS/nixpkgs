{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  importlib-metadata,
  keyring,
  pkginfo,
  readme-renderer,
  requests,
  requests-toolbelt,
  rich,
  rfc3986,
  setuptools-scm,
  urllib3,
  build,
  pretend,
  pytest-socket,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "twine";
  version = "5.1.1";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mqCCUTnAKzQ02RNUXHuEeiHINeEVl/UlWELUV9ojIts=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    importlib-metadata
    keyring
    pkginfo
    readme-renderer
    requests
    requests-toolbelt
    rfc3986
    rich
    urllib3
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
