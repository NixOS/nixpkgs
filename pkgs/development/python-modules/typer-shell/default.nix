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
  version = "0.1.12";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "FergusFettes";
    repo = "typer-shell";
    rev = "refs/tags/v${version}";
    hash = "sha256-fnqI+nKMaQocBWd9i/lqq8OzKwFdxJ8+7aYG5sNQ55E=";
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
