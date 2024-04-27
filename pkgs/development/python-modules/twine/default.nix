{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, importlib-metadata
, keyring
, pkginfo
, readme-renderer
, requests
, requests-toolbelt
, rich
, rfc3986
, setuptools-scm
, urllib3
}:

buildPythonPackage rec {
  pname = "twine";
  version = "5.0.0";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ibDMfTcKS2ZCHMYQLyaaqRD+DxhhwST1c88t3tvBDPQ=";
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

  # Requires network
  doCheck = false;

  pythonImportsCheck = [ "twine" ];

  meta = {
    description = "Collection of utilities for interacting with PyPI";
    mainProgram = "twine";
    homepage = "https://github.com/pypa/twine";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
