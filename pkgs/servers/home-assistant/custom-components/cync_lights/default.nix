{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
}:

buildHomeAssistantComponent rec {
  owner = "nikshriv";
  domain = "cync_lights";
  version = "1.0.1";

  src = fetchFromGitHub {
    inherit owner;
    repo = "cync_lights";
    rev = "f4923bf2ab343a679a78495f66289ab9961f43ba";
    hash = "sha256-MLMHpPhcICzQQ6nT9joViwhsp+x9E0kwVrlEmV8XJ0s=";
  };

  meta = with lib; {
    description = "Home Assistant Integration for controlling Cync switches, plugs, and bulbs";
    homepage = "https://github.com/nikshriv/cync_lights";
    maintainers = with maintainers; [ ndarwincorn ];
    license = licenses.unlicensed;
  };
}
