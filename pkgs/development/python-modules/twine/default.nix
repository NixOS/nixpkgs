{ lib, buildPythonPackage, fetchPypi, pythonOlder
, importlib-metadata
, keyring
, pkginfo
, pyblake2
, readme_renderer
, requests
, requests_toolbelt
, setuptools_scm
, tqdm
, colorama
, rfc3986
}:

buildPythonPackage rec {
  pname = "twine";
  version = "3.4.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a56c985264b991dc8a8f4234eb80c5af87fa8080d0c224ad8f2cd05a2c22e83b";
  };

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [
    importlib-metadata
    keyring
    pkginfo
    pyblake2
    readme_renderer
    requests
    requests_toolbelt
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
