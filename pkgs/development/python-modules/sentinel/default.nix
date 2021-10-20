{ lib, buildPythonPackage, fetchPypi}:

buildPythonPackage rec {
  pname = "sentinel";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f28143aa4716dbc8f6193f5682176a3c33cd26aaae05d9ecf66c186a9887cc2d";
  };

  meta = with lib; {
    description = "Create sentinel and singleton objects";
    homepage = "https://github.com/eddieantonio/sentinel";
    license = licenses.mit;
  };
}
