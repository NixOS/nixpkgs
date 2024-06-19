{ lib
, fetchFromGitHub
, buildHomeAssistantComponent
, beautifulsoup4
}:

buildHomeAssistantComponent rec {
  owner = "mampfes";
  domain = "epex_spot";
  version = "2.3.5";

  src = fetchFromGitHub {
    owner = "mampfes";
    repo = "ha_epex_spot";
    rev = "refs/tags/${version}";
    hash = "sha256-WmPsFfQm8ChEr41XVgKi2BGwta5aKH9GDz4iIfTAPK4=";
  };

  propagatedBuildInputs = [
    beautifulsoup4
  ];

  postPatch = ''
    substituteInPlace custom_components/epex_spot/manifest.json --replace-fail 'bs4' 'beautifulsoup4'
  '';

  #skip phases without activity
  dontConfigure = true;
  doCheck = false;
  dontBuild = true;

  meta = with lib; {
    changelog = "https://github.com/mampfes/ha_epex_spot/releases/tag/${version}";
    description = "This component adds electricity prices from stock exchange EPEX Spot to Home Assistant";
    homepage = "https://github.com/mampfes/ha_epex_spot";
    maintainers = with maintainers; [ _9R ];
    license = licenses.mit;
  };
}
