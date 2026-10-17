{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "sqlalchemy-json";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "edelooff";
    repo = "sqlalchemy-json";
    tag = "v${version}";
    hash = "sha256-Is3DznojvpWYFSDutzCxRLceQMIiS3ZIg0c//MIOF+s=";
  };

  build-system = [ setuptools ];

  dependencies = [ sqlalchemy ];

  pythonImportsCheck = [ "sqlalchemy_json" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Full-featured JSON type with mutation tracking for SQLAlchemy";
    homepage = "https://github.com/edelooff/sqlalchemy-json";
    changelog = "https://github.com/edelooff/sqlalchemy-json/tree/v${version}#changelog";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ augustebaum ];
  };
}
