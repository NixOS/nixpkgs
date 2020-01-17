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
}:

buildPythonPackage rec {
  pname = "twine";
  version = "3.1.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d561a5e511f70275e5a485a6275ff61851c16ffcb3a95a602189161112d9f160";
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
  ] ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  # Requires network
  doCheck = false;

  meta = {
    description = "Collection of utilities for interacting with PyPI";
    homepage = https://github.com/pypa/twine;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
