{ lib, fetchPypi, buildPythonPackage, user-agents }:

buildPythonPackage rec {
  pname = "home-assistant-frontend";
  version = "20181026.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b0610206eee06042847d89a581ecfcd71255b0e1ecff77e302237e8aa175b00d";
  };

  propagatedBuildInputs = [ user-agents ];

  meta = with lib; {
    description = "Polymer frontend for Home Assistant";
    homepage = https://github.com/home-assistant/home-assistant-polymer;
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
