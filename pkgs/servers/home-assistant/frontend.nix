{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  pname = "home-assistant-frontend";
  version = "20190514.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ba8cfa01b00ff2ee94a91cd83197b4d213e9b9df151daaef11dd0a56d34c5414";
  };

  # no Python tests implemented
  doCheck = false;

  meta = with lib; {
    description = "Polymer frontend for Home Assistant";
    homepage = https://github.com/home-assistant/home-assistant-polymer;
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda globin ];
  };
}
