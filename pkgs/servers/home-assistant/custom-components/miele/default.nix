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
  version = "0.1.19";

  src = fetchFromGitHub {
    inherit owner;
    repo = domain;
    rev = "refs/tags/v${version}";
    hash = "sha256-od7DV10/rkIw9eFMsTRw4bMmhQo9BAmw2rCbKKySeIk=";
  };

  propagatedBuildInputs = [
    flatdict
    pymiele
  ];

  # Makefile only used for bumping the version
  dontBuild = true;

  meta = with lib; {
    changelog = "https://github.com/astrandb/miele/releases/tag/v${version}";
    description = "A modern integration for Miele devices in Home Assistant";
    homepage = "https://github.com/astrandb/miele";
    maintainers = with maintainers; [jamiemagee];
    license = licenses.mit;
  };
}
