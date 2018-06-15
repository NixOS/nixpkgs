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
  version = "1.11.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "09cz9v63f8mrs4znbjapjj2z3wdfryq8q364zm0wzjhbzzcs9n9g";
  };

  propagatedBuildInputs = [ pkginfo requests requests_toolbelt tqdm pyblake2 ];

  # Requires network
  doCheck = false;

  meta = {
    description = "Collection of utilities for interacting with PyPI";
    homepage = https://github.com/pypa/twine;
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
