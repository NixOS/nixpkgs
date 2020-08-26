{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "wrapt";
  version = "1.12.1";

  # No tests in archive
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b62ffa81fb85f4332a4f609cab4ac40709470da05643a082ec1eb88e6d9b97d7";
  };

  meta = {
    description = "Module for decorators, wrappers and monkey patching";
    license = lib.licenses.bsd2;
    homepage = "https://github.com/GrahamDumpleton/wrapt";
  };
}
