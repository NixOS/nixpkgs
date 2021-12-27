{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "wrapt";
  version = "1.13.3";

  # No tests in archive
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fea9cd438686e6682271d36f3481a9f3636195578bab9ca3382e2f5f01fc185";
  };

  meta = {
    description = "Module for decorators, wrappers and monkey patching";
    license = lib.licenses.bsd2;
    homepage = "https://github.com/GrahamDumpleton/wrapt";
  };
}
