{
  lib,
  buildHomeAssistantComponent,
  cronsim,
  fetchFromGitHub,
}:
buildHomeAssistantComponent rec {
  owner = "frenck";
  domain = "spook";
  version = "5.5.1";

  src = fetchFromGitHub {
    inherit owner;
    repo = domain;
    tag = "v${version}";
    hash = "sha256-FT8hpWz3pv63hjUr/kiIJOzT7z/6tclj7CZ2XpQ2JYY=";
  };

  patches = [ ./remove-sub-integration-symlink-hack.patch ];

  postPatch = ''
    substituteInPlace custom_components/spook/manifest.json \
      --replace-fail '"version": "0.0.0"' '"version": "${version}"'
  '';

  dependencies = [
    cronsim
  ];

  meta = {
    changelog = "https://github.com/frenck/spook/releases/tag/v${version}";
    description = "Toolbox for Home Assistant";
    homepage = "https://spook.boo/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kkoniuszy ];
  };
}
