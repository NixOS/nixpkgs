{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "wrapt";
  version = "1.13.1";

  # No tests in archive
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "909a80ce028821c7ad01bdcaa588126825931d177cdccd00b3545818d4a195ce";
  };

  meta = {
    description = "Module for decorators, wrappers and monkey patching";
    license = lib.licenses.bsd2;
    homepage = "https://github.com/GrahamDumpleton/wrapt";
  };
}
