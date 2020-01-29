{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  # the frontend version corresponding to a specific home-assistant version can be found here
  # https://github.com/home-assistant/home-assistant/blob/master/homeassistant/components/frontend/manifest.json
  pname = "home-assistant-frontend";
  version = "20200108.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1h6fgkx8fffzs829893gjbh0wbjgxjzz2ca64v8r5sb938bfayg8";
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
