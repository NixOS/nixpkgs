{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "testpath";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05z4s4d5i1ja16hiv4jhqv63fvg1a4vw77s0ay1sw11hrl5pmkqs";
  };

  meta = with lib; {
    description = "Test utilities for code working with files and commands";
    license = licenses.mit;
    homepage = "https://github.com/jupyter/testpath";
  };

}
