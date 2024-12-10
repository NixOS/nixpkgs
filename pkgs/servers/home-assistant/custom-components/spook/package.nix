{
  lib,
  buildHomeAssistantComponent,
  fetchFromGitHub,
  pillow,
  fnv-hash-fast,
  psutil-home-assistant,
  sqlalchemy,
}:
buildHomeAssistantComponent rec {
  owner = "frenck";
  domain = "spook";
  version = "3.0.1";

  src = fetchFromGitHub {
    inherit owner;
    repo = domain;
    rev = "refs/tags/v${version}";
    hash = "sha256-ChHsevryWuim8BEFqXVkCOW9fGMrt5vol+B2SreMUws=";
  };

  patches = [ ./remove-sub-integration-symlink-hack.patch ];

  dependencies = [
    pillow
    fnv-hash-fast
    psutil-home-assistant
    sqlalchemy
  ];

  meta = {
    changelog = "https://github.com/frenck/spook/releases/tag/v${version}";
    description = "Toolbox for Home Assistant";
    homepage = "https://spook.boo/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kkoniuszy ];
  };
}
