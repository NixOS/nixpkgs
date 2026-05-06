{
  buildPythonPackage,
  fetchFromGitHub,
  geoalchemy2,
  inflect,
  lib,
  mysql-connector,
  nix-update-script,
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
  version = "4.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "agronholm";
    repo = "sqlacodegen";
    tag = finalAttrs.version;
    hash = "sha256-iiSYgGzSKDN6ivrAI0Ow5e1nCqtJMLtoM9pTkCKE65M=";
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

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Reads the structure of an existing database and generates the appropriate SQLAlchemy model code";
    homepage = "https://github.com/agronholm/sqlacodegen";
    changelog = "https://github.com/agronholm/sqlacodegen/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gaelj ];
    mainProgram = "sqlacodegen";
  };
})
