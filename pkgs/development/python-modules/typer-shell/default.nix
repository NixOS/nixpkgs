{
  lib,
  buildPythonPackage,
  click,
  click-shell,
  fetchFromGitHub,
  iterfzf,
  poetry-core,
  pythonOlder,
  pyyaml,
  rich,
  typer,
}:

buildPythonPackage rec {
  pname = "typer-shell";
  version = "0.1.10";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "FergusFettes";
    repo = "typer-shell";
    rev = "refs/tags/v${version}";
    hash = "sha256-Yr+TLEgIRy5hOAYWv9CnDVT3qm36Pzwsj60yFrzaXIQ=";
  };

  pythonRelaxDeps = [
    "iterfzf"
    "typer"
  ];

  build-system = [ poetry-core ];

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
