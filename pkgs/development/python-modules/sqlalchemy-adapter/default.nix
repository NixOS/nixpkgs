{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pycasbin,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "sqlalchemy-adapter";
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "officialpycasbin";
    repo = "sqlalchemy-adapter";
    tag = "v${version}";
    hash = "sha256-/t+4YFfrV20zy6enaL1rBrj2G06z2y71ogaN8MeLFcQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pycasbin
    sqlalchemy
  ];

  checkPhase = ''
    python3 tests/test_adapter.py
  '';

  pythonImportsCheck = [ "sqlalchemy_adapter" ];

  meta = {
    description = "SQLAlchemy Adapter for PyCasbin";
    homepage = "https://github.com/officialpycasbin/sqlalchemy-adapter";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ carlthome ];
  };
}
