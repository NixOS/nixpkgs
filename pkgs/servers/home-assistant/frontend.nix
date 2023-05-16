{ lib, fetchPypi, buildPythonPackage }:

buildPythonPackage rec {
  # the frontend version corresponding to a specific home-assistant version can be found here
  # https://github.com/home-assistant/home-assistant/blob/master/homeassistant/components/frontend/manifest.json
  pname = "home-assistant-frontend";
<<<<<<< HEAD
  version = "20230911.0";
=======
  version = "20230503.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "wheel";

  src = fetchPypi {
    inherit version format;
    pname = "home_assistant_frontend";
    dist = "py3";
    python = "py3";
<<<<<<< HEAD
    hash = "sha256-AcMZYjSbsBrfC0Oh5P+eruNILWdVmk46+p+8xLpqfuo=";
=======
    hash = "sha256-BOSXRpHgHUygrbd7LaGHFj5aM+Bfp5VkB791tJ5jCwU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # there is nothing to strip in this package
  dontStrip = true;

  # no Python tests implemented
  doCheck = false;

  meta = with lib; {
    description = "Polymer frontend for Home Assistant";
    homepage = "https://github.com/home-assistant/home-assistant-polymer";
    license = licenses.asl20;
    maintainers = teams.home-assistant.members;
  };
}
