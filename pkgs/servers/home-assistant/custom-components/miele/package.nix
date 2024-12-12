{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
  flatdict,
  pymiele,
}:

buildHomeAssistantComponent rec {
  owner = "astrandb";
  domain = "miele";
  version = "2024.11.1";

  src = fetchFromGitHub {
    inherit owner;
    repo = domain;
    rev = "refs/tags/v${version}";
    hash = "sha256-fM/ARQ4wJt2/vIVsdWpAur/YWPvBH5fOPYqiaz4DxzU=";
  };

  dependencies = [
    flatdict
    pymiele
  ];

  # Makefile only used for bumping the version
  dontBuild = true;

  meta = with lib; {
    changelog = "https://github.com/astrandb/miele/releases/tag/v${version}";
    description = "Modern integration for Miele devices in Home Assistant";
    homepage = "https://github.com/astrandb/miele";
    maintainers = with maintainers; [ jamiemagee ];
    license = licenses.mit;
  };
}
