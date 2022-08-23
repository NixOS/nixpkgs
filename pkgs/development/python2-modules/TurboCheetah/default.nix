{ lib
, buildPythonPackage
, fetchPypi
, cheetah
, nose
}:

buildPythonPackage rec {
  pname = "TurboCheetah";
  version = "1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e4c7ecb0d061bfb58281363ee1b09337083f013a8b4d0355326a5d8668f450c";
  };

  propagatedBuildInputs = [ cheetah ];

  checkInputs = [ nose ];

  meta = {
    description = "TurboGears plugin to support use of Cheetah templates";
    homepage = "http://docs.turbogears.org/TurboCheetah";
    license = lib.licenses.mit;
  };
}
