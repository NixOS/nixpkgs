{ lib
, buildPythonPackage
, fetchPypi
, pkginfo
, requests
, requests_toolbelt
, tqdm
, pyblake2
}:

buildPythonPackage rec {
  pname = "twine";
  version = "1.9.1";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "caa45b7987fc96321258cd7668e3be2ff34064f5c66d2d975b641adca659c1ab";
  };

  propagatedBuildInputs = [ pkginfo requests requests_toolbelt tqdm pyblake2 ];

  # Requires network
  doCheck = false;

  meta = {
    description = "Collection of utilities for interacting with PyPI";
    homepage = https://github.com/pypa/twine;
    license = lib.licenses.asl20;
    maintainer = with lib.maintainers; [ fridh ];
  };
}