{ lib
, python3
, fetchFromGitHub
, uv
, copier
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pspm";
  version = "1.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Jahn16";
    repo = "pspm";
    rev = "nixos";
    hash = "sha256-3d6hnSa3OyGRUAIDtuQ3SLkNgE1UjZw0srZk0O+3cBA";
  };

  build-system = [
    python3.pkgs.hatchling
  ];

  dependencies = [
    copier
    (with python3.pkgs; [
      tomli
      tomli-w
      typer
      uv
    ])
  ];

  pythonImportsCheck = [
    "pspm"
  ];

  meta = {
    description = "Python simple dependency manager";
    homepage = "https://github.com/Jahn16/pspm";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "spm";
  };
}
