{ stdenv, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "whitenoise";
  version = "4.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "42133ddd5229eeb6a0c9899496bdbe56c292394bf8666da77deeb27454c0456a";
  };

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Radically simplified static file serving for WSGI applications";
    homepage = http://whitenoise.evans.io/;
    license = licenses.mit;
  };
}
