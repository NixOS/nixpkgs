{
  buildHomeAssistantComponent,
  fetchFromGitHub,
  lib,
  alphaessopenapi,
}:
buildHomeAssistantComponent rec {
  owner = "CharlesGillanders";
  domain = "alphaess";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "CharlesGillanders";
    repo = "homeassistant-alphaESS";
    tag = "v${version}";
    hash = "sha256-xLZDmJMomk+C3l8+Of85vkbwrjQUnGlYL/UL31Kn5gc=";
  };

  dependencies = [
    alphaessopenapi
  ];

  meta = {
    description = "Monitor your energy generation, storage, and usage data using the official API from Alpha ESS";
    homepage = "https://github.com/CharlesGillanders/homeassistant-alphaESS";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ benediktbroich ];
  };
}
