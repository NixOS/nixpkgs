{ lib, fetchPypi, buildPythonPackage, user-agents }:

buildPythonPackage rec {
  pname = "home-assistant-frontend";
  version = "20190331.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2d266a4d3d31af9a50debb99b0e9e9650044698f9157753bec785785057264cf";
  };

  propagatedBuildInputs = [ user-agents ];

  # no Python tests implemented
  doCheck = false;

  meta = with lib; {
    description = "Polymer frontend for Home Assistant";
    homepage = https://github.com/home-assistant/home-assistant-polymer;
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda ];
  };
}
