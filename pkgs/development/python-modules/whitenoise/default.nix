{ lib, stdenv, fetchPypi, buildPythonPackage, isPy27 }:

buildPythonPackage rec {
  pname = "whitenoise";
  version = "5.2.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "05ce0be39ad85740a78750c86a93485c40f08ad8c62a6006de0233765996e5c7";
  };

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "Radically simplified static file serving for WSGI applications";
    homepage = "http://whitenoise.evans.io/";
    license = licenses.mit;
  };
}
