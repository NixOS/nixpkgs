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
  version = "2025.1.1";

  src = fetchFromGitHub {
    inherit owner;
    repo = domain;
    tag = "v${version}";
    hash = "sha256-TShy2q3gKqTgRU3u4Wp7zQjzhEogqUVip8EkH8XIYw8=";
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
