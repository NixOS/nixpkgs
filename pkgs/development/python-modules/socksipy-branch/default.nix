{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "socksipy-branch";
  version = "1.01";

  src = fetchPypi {
    pname = "SocksiPy-branch";
    inherit version;
    hash = "sha256-F6lQYOKMO5A4qbjBhlxU+MHFvvFdVhv3d8m788gOhAY=";
  };

  meta = with lib; {
    homepage = "http://code.google.com/p/socksipy-branch/";
    description = "This Python module allows you to create TCP connections through a SOCKS proxy without any special effort";
    license = licenses.bsd3;
  };
}
