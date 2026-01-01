{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  beautifulsoup4,
}:

buildHomeAssistantComponent rec {
  owner = "mampfes";
  domain = "epex_spot";
<<<<<<< HEAD
  version = "4.0.0";
=======
  version = "3.0.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "mampfes";
    repo = "ha_epex_spot";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-kpyWBeKZ0WUoWI/KwKUo/U3RVz2Kdn4xe5WHWr2pV+U=";
=======
    hash = "sha256-UaPgf0861TaSgawjJCyNjs8hRE5L5vWnyoXENrzCfb4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  dependencies = [
    beautifulsoup4
  ];

  #skip phases without activity
  dontConfigure = true;
  doCheck = false;

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/mampfes/ha_epex_spot/releases/tag/${version}";
    description = "This component adds electricity prices from stock exchange EPEX Spot to Home Assistant";
    homepage = "https://github.com/mampfes/ha_epex_spot";
    maintainers = with lib.maintainers; [ _9R ];
    license = lib.licenses.mit;
=======
  meta = with lib; {
    changelog = "https://github.com/mampfes/ha_epex_spot/releases/tag/${version}";
    description = "This component adds electricity prices from stock exchange EPEX Spot to Home Assistant";
    homepage = "https://github.com/mampfes/ha_epex_spot";
    maintainers = with maintainers; [ _9R ];
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
