{
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  lib,
  pytestCheckHook,
  typer,
}:

buildPythonPackage rec {
  pname = "typer-injector";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "BenjyWiener";
    repo = "typer-injector";
    tag = "v${version}";
    hash = "sha256-rhYeTNQh1DZuQ7/yNleZPMMBiF29OrcT0vr/yb5HJXk=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    typer
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
