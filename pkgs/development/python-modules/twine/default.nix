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
  version = "3.4.2";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4caec0f1ed78dc4c9b83ad537e453d03ce485725f2aea57f1bb3fdde78dae936";
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
