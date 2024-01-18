{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "units";
  version = "0.07";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "43eb3e073e1b11289df7b1c3f184b5b917ccad178b717b03933298716f200e14";
  };

  meta = with lib; {
    description = "Python support for quantities with units";
    homepage = "https://bitbucket.org/adonohue/units/";
    license = licenses.psfl;
    maintainers = [ ];
  };
}
