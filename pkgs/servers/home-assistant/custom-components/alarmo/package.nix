{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
}:

buildHomeAssistantComponent rec {
  owner = "nielsfaber";
  domain = "alarmo";
  version = "1.10.8";

  src = fetchFromGitHub {
    owner = "nielsfaber";
    repo = "alarmo";
    tag = "v${version}";
    hash = "sha256-XfeUjZ9icgWFfeJabib1KlrGuGJKuoOZuJH/OFMw/4M=";
  };

  postPatch = ''
    find ./custom_components/alarmo/frontend -mindepth 1 -maxdepth 1 ! -name "dist" -exec rm -rf {} \;
  '';

  meta = with lib; {
    changelog = "https://github.com/nielsfaber/alarmo/releases/tag/v${version}";
    description = "Alarm System for Home Assistant";
    homepage = "https://github.com/nielsfaber/alarmo";
    maintainers = with maintainers; [ mindstorms6 ];
    license = licenses.unfree;
  };
}
