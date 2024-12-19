{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  msmart-ng,
}:

buildHomeAssistantComponent rec {
  owner = "mill1000";
  domain = "midea_ac";
  version = "2024.10.4";

  src = fetchFromGitHub {
    owner = "mill1000";
    repo = "midea-ac-py";
    rev = version;
    hash = "sha256-P/s8HMP9xQWI+bgy6JHe4pAx+jItpK6BCWIyKsfTjmg=";
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
