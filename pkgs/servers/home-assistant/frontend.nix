{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  # the frontend version corresponding to a specific home-assistant version can be found here
  # https://github.com/home-assistant/home-assistant/blob/master/homeassistant/components/frontend/manifest.json
  pname = "home-assistant-frontend";
  version = "20191204.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1agbc8laql9vb9f8qnha2zwah967avfyna0ckdyvvdd6sjwkc0a2";
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
