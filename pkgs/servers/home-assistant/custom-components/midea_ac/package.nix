{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  msmart-ng,
}:

buildHomeAssistantComponent rec {
  owner = "mill1000";
  domain = "midea_ac";
  version = "2025.3.1";

  src = fetchFromGitHub {
    owner = "mill1000";
    repo = "midea-ac-py";
    tag = version;
    hash = "sha256-oO+t0my72PwWWUAzr8blA3Q8uJyICZNcfoOHsLFL3MQ=";
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
