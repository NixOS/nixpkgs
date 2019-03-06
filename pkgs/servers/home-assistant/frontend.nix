{ lib, fetchPypi, buildPythonPackage, user-agents }:

buildPythonPackage rec {
  pname = "home-assistant-frontend";
  version = "20190203.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8f71a63e1c35ec088ed46e4529b30df7dd44f4968d84068306718c912d3a1410";
  };

  propagatedBuildInputs = [ user-agents ];

  meta = with lib; {
    description = "Polymer frontend for Home Assistant";
    homepage = https://github.com/home-assistant/home-assistant-polymer;
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
