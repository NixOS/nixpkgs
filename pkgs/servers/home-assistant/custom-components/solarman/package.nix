{
  buildHomeAssistantComponent,
  fetchFromGitHub,
  lib,
  pysolarmanv5,
  pyyaml,
}:

buildHomeAssistantComponent rec {
  owner = "StephanJoubert";
  domain = "solarman";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "StephanJoubert";
    repo = "home_assistant_solarman";
    tag = version;
    hash = "sha256-+znRq7LGIxbxMEypIRqbIMgV8H4OyiOakmExx1aHEl8=";
  };

  dependencies = [
    pysolarmanv5
    pyyaml
  ];

  meta = {
    description = "Home Assistant component for Solarman collectors used with a variety of inverters";
    changelog = "https://github.com/StephanJoubert/home_assistant_solarman/releases/tag/${version}";
    homepage = "https://github.com/StephanJoubert/home_assistant_solarman";
    maintainers = with lib.maintainers; [ Scrumplex ];
    license = lib.licenses.asl20;
  };
}
