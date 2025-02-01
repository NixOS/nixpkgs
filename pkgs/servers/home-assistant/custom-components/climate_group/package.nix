{
  lib,
  fetchFromGitHub,
  buildHomeAssistantComponent,
}:
buildHomeAssistantComponent rec {
  owner = "bjrnptrsn";
  domain = "climate_group";
  version = "1.0.7";

  src = fetchFromGitHub {
    inherit owner;
    repo = "climate_group";
    rev = "refs/tags/${version}";
    hash = "sha256-f/VQUNzRSxmKGNgijaafQ5NbngUUKmcdkafYC3Ol9qM=";
  };

  dontBuild = true;

  meta = {
    changelog = "https://github.com/bjrnptrsn/climate_group/blob/${src.rev}/README.md#changelog";
    description = "Group multiple climate devices to a single entity";
    homepage = "https://github.com/bjrnptrsn/climate_group";
    maintainers = builtins.attrValues { inherit (lib.maintainers) jamiemagee; };
    license = lib.licenses.mit;
  };
}
