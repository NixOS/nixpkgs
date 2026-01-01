{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  home-connect-async,
}:

buildHomeAssistantComponent rec {
  owner = "ekutner";
  domain = "home_connect_alt";
<<<<<<< HEAD
  version = "1.3.4";
=======
  version = "1.3.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "ekutner";
    repo = "home-connect-hass";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-X6yRoEJAmBDQzEo8WeEOMFZHJ6OOpw+XUKi+iHHOgOw=";
=======
    hash = "sha256-t5Af58HgYVMZki/93t63X2JPXDJm7PPt84yGj7MJKkE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  dependencies = [ home-connect-async ];

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/ekutner/home-connect-hass/releases/tag/${src.tag}";
    description = "Alternative (and improved) Home Connect integration for Home Assistant";
    homepage = "https://github.com/ekutner/home-connect-hass";
    maintainers = with lib.maintainers; [ kranzes ];
    license = lib.licenses.mit;
=======
  meta = with lib; {
    changelog = "https://github.com/ekutner/home-connect-hass/releases/tag/${src.tag}";
    description = "Alternative (and improved) Home Connect integration for Home Assistant";
    homepage = "https://github.com/ekutner/home-connect-hass";
    maintainers = with maintainers; [ kranzes ];
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
