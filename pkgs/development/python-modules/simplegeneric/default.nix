{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "simplegeneric";
  version = "0.8.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    hash = "sha256-3JcuBglLmvW4VbPfSmRjleQ9HJ0NOe00W3OTVg0LkXM=";
  };

  meta = {
    description = "Simple generic functions";
    homepage = "http://cheeseshop.python.org/pypi/simplegeneric";
    license = lib.licenses.zpl21;
  };
}
