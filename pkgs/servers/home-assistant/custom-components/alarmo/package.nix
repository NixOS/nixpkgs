{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
}:

buildHomeAssistantComponent rec {
  owner = "nielsfaber";
  domain = "alarmo";
  version = "1.10.4";

  postInstall = ''
    cd $out/custom_components/alarmo/frontend
    ls . | grep -v dist | xargs rm -rf
  '';

  src = fetchFromGitHub {
    owner = "nielsfaber";
    repo = "alarmo";
    rev = "refs/tags/v${version}";
    hash = "sha256-/hNzGPckLHUX0mrBF3ugAXstrOc1mWdati+nRJCwldc=";
  };

  meta = with lib; {
    changelog = "https://github.com/nielsfaber/alarmo/releases/tag/v${version}";
    description = "Alarm System for Home Assistant";
    homepage = "https://github.com/nielsfaber/alarmo";
    maintainers = with maintainers; [ mindstorms6 ];
    license = licenses.unfree;
  };
}
