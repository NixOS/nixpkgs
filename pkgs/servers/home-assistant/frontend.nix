{ lib, fetchPypi, buildPythonPackage, user-agents }:

buildPythonPackage rec {
  pname = "home-assistant-frontend";
  version = "20190321.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0sk96mnmvsbcqjjcrlgfsxkywms0zmajjgn3ibvk4sfn5wn53bg7";
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
