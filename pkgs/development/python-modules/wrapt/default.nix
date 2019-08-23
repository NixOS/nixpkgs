{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "wrapt";
  version = "1.11.1";

  # No tests in archive
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4aea003270831cceb8a90ff27c4031da6ead7ec1886023b80ce0dfe0adf61533";
  };

  meta = {
    description = "Module for decorators, wrappers and monkey patching";
    license = lib.licenses.bsd2;
    homepage = https://github.com/GrahamDumpleton/wrapt;
  };
}