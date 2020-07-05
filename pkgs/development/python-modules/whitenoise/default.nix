{ stdenv, fetchPypi, buildPythonPackage, isPy27 }:

buildPythonPackage rec {
  pname = "whitenoise";
  version = "5.1.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "60154b976a13901414a25b0273a841145f77eb34a141f9ae032a0ace3e4d5b27";
  };

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Radically simplified static file serving for WSGI applications";
    homepage = "http://whitenoise.evans.io/";
    license = licenses.mit;
  };
}
