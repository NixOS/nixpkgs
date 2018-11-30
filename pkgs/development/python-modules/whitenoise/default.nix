{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "whitenoise";
  version = "4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1e206c5adfb849942ddd057e599ac472ec1a85d56ae78a5ba24f243ea46a89c5";
  };

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Radically simplified static file serving for WSGI applications";
    homepage = http://whitenoise.evans.io/;
    license = licenses.mit;
  };
}
