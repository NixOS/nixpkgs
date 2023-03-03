{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, importlib-metadata
, keyring
, pkginfo
, readme_renderer
, requests
, requests-toolbelt
, rich
, rfc3986
, setuptools-scm
, urllib3
}:

buildPythonPackage rec {
  pname = "twine";
  version = "4.0.2";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-nhAu9f3VogZh64j61GM4gGw70yzx23KWA/42l7G8g8g=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    importlib-metadata
    keyring
    pkginfo
    readme_renderer
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
    homepage = "https://github.com/pypa/twine";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
