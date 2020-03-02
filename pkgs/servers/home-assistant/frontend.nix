{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  # the frontend version corresponding to a specific home-assistant version can be found here
  # https://github.com/home-assistant/home-assistant/blob/master/homeassistant/components/frontend/manifest.json
  pname = "home-assistant-frontend";
  version = "20200220.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0cb8b6xizxz1q5r0qgwsqs53va9bxdqnp4vwf5lh8ppv9zy7hssc";
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
