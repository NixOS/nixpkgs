{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "whitenoise";
  version = "4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "32b57d193478908a48acb66bf73e7a3c18679263e3e64bfebcfac1144a430039";
  };

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Radically simplified static file serving for WSGI applications";
    homepage = http://whitenoise.evans.io/;
    license = licenses.mit;
  };
}
