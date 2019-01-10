{ lib, fetchPypi, buildPythonPackage, user-agents }:

buildPythonPackage rec {
  pname = "home-assistant-frontend";
  version = "20190109.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d4e0241feca3779af67efe906be31ba3fac76e8fb3e46d8416f349f5ec3009a6";
  };

  propagatedBuildInputs = [ user-agents ];

  meta = with lib; {
    description = "Polymer frontend for Home Assistant";
    homepage = https://github.com/home-assistant/home-assistant-polymer;
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
