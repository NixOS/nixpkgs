{
  lib,
  buildPythonPackage,
  click-shell,
  click,
  fetchFromGitHub,
  hatchling,
  iterfzf,
  pythonOlder,
  pyyaml,
  rich,
  typer,
}:

buildPythonPackage rec {
  pname = "typer-shell";
  version = "1.0.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "FergusFettes";
    repo = "typer-shell";
    tag = "v${version}";
    hash = "sha256-vjinzBCaEPWbroxT7OmUQIvtwlPivYO0soGqvyRXVc4=";
  };

  pythonRelaxDeps = [
    "iterfzf"
    "rich"
    "typer"
  ];

  build-system = [ hatchling ];

  dependencies = [
    click
    click-shell
    iterfzf
    pyyaml
    rich
    typer
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "typer_shell" ];

  meta = with lib; {
    description = "Library for making beautiful shells/REPLs with Typer";
    homepage = "https://github.com/FergusFettes/typer-shell";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
