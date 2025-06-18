{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  msmart-ng,
}:

buildHomeAssistantComponent rec {
  owner = "mill1000";
  domain = "midea_ac";
  version = "2025.5.1";

  src = fetchFromGitHub {
    owner = "mill1000";
    repo = "midea-ac-py";
    tag = version;
    hash = "sha256-6CNxhgygAyzpy3idj3RkVvI8WMHCfar9v0GG21Y7YKE=";
  };

  dependencies = [ msmart-ng ];

  meta = with lib; {
    description = "Home Assistant custom integration to control Midea (and associated brands) air conditioners via LAN";
    homepage = "https://github.com/mill1000/midea-ac-py";
    license = licenses.mit;
    maintainers = with maintainers; [
      hexa
      emilylange
    ];
  };
}
