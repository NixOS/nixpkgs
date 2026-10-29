{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  beautifulsoup4,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "mampfes";
  domain = "epex_spot";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "mampfes";
    repo = "ha_epex_spot";
    tag = finalAttrs.version;
    hash = "sha256-FLXvnKuo74nAGIo+6dbn1/wzJCXWo+IltoXrxd4aEio=";
  };

  dependencies = [
    beautifulsoup4
  ];

  #skip phases without activity
  dontConfigure = true;
  doCheck = false;

  meta = {
    changelog = "https://github.com/mampfes/ha_epex_spot/releases/tag/${finalAttrs.version}";
    description = "This component adds electricity prices from stock exchange EPEX Spot to Home Assistant";
    homepage = "https://github.com/mampfes/ha_epex_spot";
    maintainers = with lib.maintainers; [ _9R ];
    license = lib.licenses.mit;
  };
})
