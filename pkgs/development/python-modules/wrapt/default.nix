{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "wrapt";
  version = "1.11.2";

  # No tests in archive
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "565a021fd19419476b9362b05eeaa094178de64f8361e44468f9e9d7843901e1";
  };

  meta = {
    description = "Module for decorators, wrappers and monkey patching";
    license = lib.licenses.bsd2;
    homepage = https://github.com/GrahamDumpleton/wrapt;
  };
}