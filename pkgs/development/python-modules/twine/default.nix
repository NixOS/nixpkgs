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
  version = "3.7.1";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "28460a3db6b4532bde6a5db6755cf2dce6c5020bada8a641bb2c5c7a9b1f35b8";
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
