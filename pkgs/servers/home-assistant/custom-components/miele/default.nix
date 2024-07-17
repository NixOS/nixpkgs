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
  version = "2024.3.0";

  src = fetchFromGitHub {
    inherit owner;
    repo = domain;
    rev = "refs/tags/v${version}";
    hash = "sha256-J9n4PFcd87L301B2YktrLcxp5Vu1HwDeCYnrMEJ0+TA=";
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
    maintainers = with maintainers; [ jamiemagee ];
    license = licenses.mit;
  };
}
