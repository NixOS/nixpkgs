{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  aiofiles,
  casttube,
  websocket-client,
  wakeonlan,
}:

buildHomeAssistantComponent rec {
  owner = "ollo69";
  domain = "samsungtv_smart";
  version = "0.14.5";

  src = fetchFromGitHub {
    owner = "ollo69";
    repo = "ha-samsungtv-smart";
    tag = "v${version}";
    hash = "sha256-J3+HD/jMJDIBSiVJnHvjOJ3yswck+DV3XpPqIoR5/sU=";
  };

  dependencies = [
    aiofiles
    casttube
    websocket-client
    wakeonlan
  ];

  meta = with lib; {
    changelog = "https://github.com/ollo69/ha-samsungtv-smart/releases/tag/v${version}";
    description = "Home Assistant Samsung TV Integration";
    homepage = "https://github.com/ollo69/ha-samsungtv-smart";
    maintainers = with maintainers; [ mindstorms6 ];
    license = licenses.asl20;
  };
}
