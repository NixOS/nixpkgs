{ lib, fetchPypi, buildPythonPackage, isPy27 }:

buildPythonPackage rec {
  pname = "whitenoise";
  version = "5.3.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "d234b871b52271ae7ed6d9da47ffe857c76568f11dd30e28e18c5869dbd11e12";
  };

  # No tests
  doCheck = false;

  meta = with lib; {
    description = "Radically simplified static file serving for WSGI applications";
    homepage = "http://whitenoise.evans.io/";
    license = licenses.mit;
  };
}
