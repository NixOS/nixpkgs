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
  version = "0.14.4";

  src = fetchFromGitHub {
    owner = "ollo69";
    repo = "ha-samsungtv-smart";
    tag = "v${version}";
    hash = "sha256-naogq/7yGj2OD93JayOH8kHZhyDsKkWa2v+lKL0FlPU=";
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
