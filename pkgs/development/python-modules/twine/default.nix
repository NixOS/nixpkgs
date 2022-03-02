{ lib, buildPythonPackage, fetchPypi, pythonOlder
, importlib-metadata
, keyring
, pkginfo
, pyblake2
, readme_renderer
, requests
, requests-toolbelt
, setuptools-scm
, tqdm
, colorama
, rfc3986
}:

buildPythonPackage rec {
  pname = "twine";
  version = "3.8.0";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-jvpSZY4K53BoahO2dVaTKPH7qYN+XeGGe/5fRqmu/hk=";
  };

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [
    importlib-metadata
    keyring
    pkginfo
    pyblake2
    readme_renderer
    requests
    requests-toolbelt
    tqdm
    colorama
    rfc3986
  ];

  # Requires network
  doCheck = false;

  meta = {
    description = "Collection of utilities for interacting with PyPI";
    homepage = "https://github.com/pypa/twine";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
