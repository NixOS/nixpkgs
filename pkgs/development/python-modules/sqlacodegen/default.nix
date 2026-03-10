{
  buildPythonPackage,
  fetchFromGitHub,
  geoalchemy2,
  inflect,
  lib,
  mysql-connector,
  pgvector,
  psycopg,
  pytestCheckHook,
  setuptools-scm,
  sqlalchemy-citext,
  sqlalchemy,
  sqlmodel,
}:

buildPythonPackage (finalAttrs: {
  pname = "sqlacodegen";
  version = "4.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "agronholm";
    repo = "sqlacodegen";
    tag = finalAttrs.version;
    hash = "sha256-rB8LVCaMDVte8UU+KLDTJnAxoTWfAtrsBZ6ToCkkyOs=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    inflect
    sqlalchemy
  ];

  nativeBuildInputs = [
    geoalchemy2
    pgvector
    sqlalchemy-citext
    sqlmodel
  ];

  nativeCheckInputs = [
    mysql-connector
    psycopg
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sqlacodegen" ];

  preCheck = ''
    export PATH="$out/bin:$PATH"
  '';

  meta = {
    description = "Reads the structure of an existing database and generates the appropriate SQLAlchemy model code";
    homepage = "https://github.com/agronholm/sqlacodegen";
    changelog = "https://github.com/agronholm/sqlacodegen/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gaelj ];
    mainProgram = "sqlacodegen";
  };
})
