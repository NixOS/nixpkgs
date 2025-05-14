{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
  sqlalchemy,
}:

buildPythonPackage rec {
  pname = "sqlalchemy-utc";
  version = "0.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "spoqa";
    repo = "sqlalchemy-utc";
    tag = version;
    hash = "sha256-ZtUuwUDgd/ngOQoWu8IgOldTbTGoFbv5Y0Hyha1KTrE=";
  };

  build-system = [ setuptools ];

  dependencies = [ sqlalchemy ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sqlalchemy_utc" ];

  disabledTests = [
    # ArgumentError
    "test_utcnow_timezone"
  ];

  meta = {
    description = "SQLAlchemy type to store aware datetime values";
    homepage = "https://github.com/spoqa/sqlalchemy-utc";
    changelog = "https://github.com/spoqa/sqlalchemy-utc/blob/${src.tag}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
