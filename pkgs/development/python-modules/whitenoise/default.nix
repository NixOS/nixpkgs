{ stdenv, fetchPypi, buildPythonPackage, isPy27 }:

buildPythonPackage rec {
  pname = "whitenoise";
  version = "5.0.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0f9137f74bd95fa54329ace88d8dc695fbe895369a632e35f7a136e003e41d73";
  };

  # No tests
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Radically simplified static file serving for WSGI applications";
    homepage = http://whitenoise.evans.io/;
    license = licenses.mit;
  };
}
