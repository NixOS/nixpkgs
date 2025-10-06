{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
}:

buildHomeAssistantComponent rec {
  owner = "nielsfaber";
  domain = "alarmo";
  version = "1.10.11";

  src = fetchFromGitHub {
    owner = "nielsfaber";
    repo = "alarmo";
    tag = "v${version}";
    hash = "sha256-OASgIudnxPtWiBLpkiOioCRhIqlr2B5E2/XGlhs16sQ=";
  };

  postPatch = ''
    find ./custom_components/alarmo/frontend -mindepth 1 -maxdepth 1 ! -name "dist" -exec rm -rf {} \;
  '';

  meta = {
    changelog = "https://github.com/nielsfaber/alarmo/releases/tag/v${version}";
    description = "Alarm System for Home Assistant";
    homepage = "https://github.com/nielsfaber/alarmo";
    maintainers = with lib.maintainers; [ mindstorms6 ];
    license = lib.licenses.asl20;
  };
}
