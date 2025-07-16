{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sqlalchemy-adapter";
  version = "1.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "sqlalchemy_adapter";
    inherit version;
    hash = "sha256-5Ze10tVKRWvc+KPHWGsjjAKqVoi7PnRoKAw3zJXme+U=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = with python3.pkgs; [
    casbin
    sqlalchemy
  ];

  pythonImportsCheck = [
    "sqlalchemy_adapter"
  ];

  meta = {
    description = "SQLAlchemy Adapter for PyCasbin";
    homepage = "https://pypi.org/project/sqlalchemy-adapter/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "sqlalchemy-adapter";
  };
}
