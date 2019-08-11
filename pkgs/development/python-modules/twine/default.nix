{ lib
, buildPythonPackage
, fetchPypi
, pkginfo
, requests
, requests_toolbelt
, tqdm
, pyblake2
, readme_renderer
}:

buildPythonPackage rec {
  pname = "twine";
  version = "1.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d6c29c933ecfc74e9b1d9fa13aa1f87c5d5770e119f5a4ce032092f0ff5b14dc";
  };

  propagatedBuildInputs = [ pkginfo requests requests_toolbelt tqdm pyblake2 readme_renderer ];

  # Requires network
  doCheck = false;

  meta = {
    description = "Collection of utilities for interacting with PyPI";
    homepage = https://github.com/pypa/twine;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
