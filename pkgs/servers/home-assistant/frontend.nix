{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  # the frontend version corresponding to a specific home-assistant version can be found here
  # https://github.com/home-assistant/home-assistant/blob/master/homeassistant/components/frontend/manifest.json
  pname = "home-assistant-frontend";
  version = "20201212.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nz5f7bpj0xs740af8i6j33idff6yzx7z9vydlah2sxcdgpwmz84";
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
