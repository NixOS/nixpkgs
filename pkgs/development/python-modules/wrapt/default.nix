{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "wrapt";
  version = "1.10.11";

  # No tests in archive
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "d4d560d479f2c21e1b5443bbd15fe7ec4b37fe7e53d335d3b9b0a7b1226fe3c6";
  };

  meta = {
    description = "Module for decorators, wrappers and monkey patching";
    license = lib.licenses.bsd2;
    homepage = https://github.com/GrahamDumpleton/wrapt;
  };
}