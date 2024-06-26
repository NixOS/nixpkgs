{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
}:

buildHomeAssistantComponent rec {
  owner = "georgezhao2010";
  domain = "midea_ac_lan";
  version = "0.3.22";

  src = fetchFromGitHub {
    inherit owner;
    repo = domain;
    rev = "v${version}";
    hash = "sha256-xTnbA4GztHOE61QObEJbzUSdbuSrhbcJ280DUDdM+n4=";
  };

  meta = with lib; {
    description = "Auto-configure and then control your Midea M-Smart devices (Air conditioner, Fan, Water heater, Washer, etc) via local area network";
    homepage = "https://github.com/georgezhao2010/midea_ac_lan/";
    changelog = "https://github.com/georgezhao2010/midea_ac_lan/releases/tag/v${version}";
    maintainers = with maintainers; [ k900 ];
    license = licenses.mit;
  };
}
