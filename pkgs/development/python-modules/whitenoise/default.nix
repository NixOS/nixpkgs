{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "whitenoise";
  version = "4.1.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "22f79cf8f1f509639330f93886acaece8ec5ac5e9600c3b981d33c34e8a42dfd";
  };

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Radically simplified static file serving for WSGI applications";
    homepage = http://whitenoise.evans.io/;
    license = licenses.mit;
  };
}
