{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
}:
buildHomeAssistantComponent rec {
  owner = "bjrnptrsn";
  domain = "climate_group";
  version = "1.0.8";

  src = fetchFromGitHub {
    inherit owner;
    repo = "climate_group";
    tag = version;
    hash = "sha256-HwMHhrmQ+fbdLHQAM+ka/1oNCIBFaLTqOlPMzCEEeQ0=";
  };

  meta = {
    changelog = "https://github.com/bjrnptrsn/climate_group/blob/${src.rev}/README.md#changelog";
    description = "Group multiple climate devices to a single entity";
    homepage = "https://github.com/bjrnptrsn/climate_group";
    maintainers = builtins.attrValues { inherit (lib.maintainers) jamiemagee; };
    license = lib.licenses.mit;
  };
}
