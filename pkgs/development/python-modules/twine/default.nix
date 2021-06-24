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
  version = "3.2.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "34352fd52ec3b9d29837e6072d5a2a7c6fe4290e97bba46bb8d478b5c598f7ab";
  };

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [
    keyring
    pkginfo
    pyblake2
    readme_renderer
    requests
    requests_toolbelt
    tqdm
    colorama
    rfc3986
  ] ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  # Requires network
  doCheck = false;

  meta = {
    description = "Collection of utilities for interacting with PyPI";
    homepage = "https://github.com/pypa/twine";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
