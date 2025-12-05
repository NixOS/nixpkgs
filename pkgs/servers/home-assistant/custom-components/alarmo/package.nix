{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
}:

buildHomeAssistantComponent rec {
  owner = "nielsfaber";
  domain = "alarmo";
  version = "1.10.13";

  src = fetchFromGitHub {
    owner = "nielsfaber";
    repo = "alarmo";
    tag = "v${version}";
    hash = "sha256-TIdgJBC2oGnxfdUHCaIlq6GYUiqLzc9F0ZF4RUILkog=";
  };

  postPatch = ''
    find ./custom_components/alarmo/frontend -mindepth 1 -maxdepth 1 ! -name "dist" -exec rm -rf {} \;
  '';

  meta = with lib; {
    changelog = "https://github.com/nielsfaber/alarmo/releases/tag/v${version}";
    description = "Alarm System for Home Assistant";
    homepage = "https://github.com/nielsfaber/alarmo";
    maintainers = with maintainers; [ mindstorms6 ];
    license = licenses.asl20;
  };
}
