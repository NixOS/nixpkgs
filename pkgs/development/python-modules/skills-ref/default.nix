{
  lib,
  buildPythonPackage,
  click,
  fetchFromGitHub,
  hatchling,
  nix-update-script,
  strictyaml,
}:

buildPythonPackage {
  pname = "skills-ref";
  version = "0.1.0-unstable-2026-02-15";
  __structuredAttrs = true;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "agentskills";
    repo = "agentskills";
    rev = "492e1b71046249d085444cad81d47985836c451b";
    hash = "sha256-1yWmiz9x5cOtSybkT3YVDYhVj2XUm3NL3IvgrStuf4s=";
  };
  sourceRoot = "source/skills-ref";

  build-system = [ hatchling ];

  dependencies = [
    click
    strictyaml
  ];

  pythonImportsCheck = [ "skills_ref" ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Reference library for Agent Skills";
    homepage = "https://github.com/agentskills/agentskills";
    license = lib.licenses.asl20;
    mainProgram = "skills-ref";
    maintainers = with lib.maintainers; [ steveej ];
  };
}
