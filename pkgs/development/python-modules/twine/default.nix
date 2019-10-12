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
  version = "1.15.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11rpd653zcgzkq3sgwkzs3mpxl3r5rij59745ni84ikv8smjmlm3";
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
