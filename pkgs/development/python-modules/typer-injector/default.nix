{
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  lib,
  pytestCheckHook,
  typer-slim,
}:

buildPythonPackage rec {
  pname = "typer-injector";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BenjyWiener";
    repo = "typer-injector";
    tag = "v${version}";
    hash = "sha256-nwEYFw+4jeF/SoaZWR51VWRezqBFjGoLiVgJWdPNoIk=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    typer-slim
  ];

  pythonImportsCheck = [ "typer_injector" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Dependency injection for Typer";
    homepage = "https://github.com/BenjyWiener/typer-injector";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
