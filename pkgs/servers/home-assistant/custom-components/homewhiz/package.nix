{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,

  aiohttp,
  awsiotsdk,
  bleak,
  bleak-retry-connector,
  bidict,
  dacite,
}:

buildHomeAssistantComponent (finalAttrs: {
  owner = "home-assistant-HomeWhiz";
  domain = "homewhiz";
  version = "0.5.27";

  src = fetchFromGitHub {
    owner = "home-assistant-HomeWhiz";
    repo = "home-assistant-HomeWhiz";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r8+1y6QruTdRr0XLy2jqD46VomvnkLwFoXp69d+lyzk=";
  };

  dependencies = [
    aiohttp
    awsiotsdk
    bidict
    bleak
    bleak-retry-connector
    dacite
  ];

  meta = {
    changelog = "https://github.com/home-assistant-HomeWhiz/home-assistant-HomeWhiz/releases/tag/${finalAttrs.src.tag}";
    description = "Home Assistant custom component for devices that can connect to HomeWhiz mobile app (Beko, Grundig, Arcelik)";
    homepage = "https://github.com/home-assistant-HomeWhiz/home-assistant-HomeWhiz";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rdk31 ];
  };
})
