{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  # the frontend version corresponding to a specific home-assistant version can be found here
  # https://github.com/home-assistant/home-assistant/blob/master/homeassistant/components/frontend/manifest.json
  pname = "home-assistant-frontend";
  version = "20200519.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kdwkn4586qqcp0l0v5z9j2awwgcw0hqi8wwv7h8xss97dh0ybdv";
  };

  # no Python tests implemented
  doCheck = false;

  meta = with lib; {
    description = "Polymer frontend for Home Assistant";
    homepage = "https://github.com/home-assistant/home-assistant-polymer";
    license = licenses.asl20;
    maintainers = with maintainers; [ dotlambda globin ];
  };
}
