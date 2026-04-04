{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  sqlalchemy,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "sqlalchemy-utc";
  version = "0.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "spoqa";
    repo = "sqlalchemy-utc";
    tag = finalAttrs.version;
    hash = "sha256-ZtUuwUDgd/ngOQoWu8IgOldTbTGoFbv5Y0Hyha1KTrE=";
  };

  patches = [
    # https://github.com/spoqa/sqlalchemy-utc/pull/20
    ./sqlalchemy2-compat.patch
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    sqlalchemy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sqlalchemy_utc"
  ];

  meta = {
    description = "SQLAlchemy type to store aware datetime values";
    homepage = "https://github.com/spoqa/sqlalchemy-utc";
    changelog = "https://github.com/spoqa/sqlalchemy-utc/blob/${finalAttrs.src.rev}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
