{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "units";
  version = "0.07";

  src = fetchPypi {
    inherit pname version;
    sha256 = "43eb3e073e1b11289df7b1c3f184b5b917ccad178b717b03933298716f200e14";
  };

  meta = with lib; {
    description = "Python support for quantities with units";
    homepage = "https://bitbucket.org/adonohue/units/";
    license = licenses.psfl;
<<<<<<< HEAD
    maintainers = [ ];
=======
    maintainers = [ maintainers.costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
