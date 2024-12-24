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
    sha256 = "dc972e06094b9af5b855b3df4a646395e43d1c9d0d39ed345b7393560d0b9173";
  };

  meta = {
    description = "Simple generic functions";
    homepage = "http://cheeseshop.python.org/pypi/simplegeneric";
    license = lib.licenses.zpl21;
  };
}
