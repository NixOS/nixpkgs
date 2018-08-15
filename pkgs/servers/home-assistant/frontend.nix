{ lib, fetchPypi, buildPythonPackage, user-agents }:

buildPythonPackage rec {
  pname = "home-assistant-frontend";
  version = "20180804.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "50a9e74efe2b56fbc34fba07205829e0ea77315183e85c235d177cabff3b62ee";
  };

  propagatedBuildInputs = [ user-agents ];

  meta = with lib; {
    description = "Polymer frontend for Home Assistant";
    homepage = https://github.com/home-assistant/home-assistant-polymer;
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
