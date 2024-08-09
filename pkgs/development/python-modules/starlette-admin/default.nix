{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  aiosqlite,
  arrow,
  babel,
  cacert,
  colour,
  fasteners,
  httpx,
  jinja2,
  mongoengine,
  motor,
  passlib,
  phonenumbers,
  pillow,
  psycopg2,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  python-multipart,
  requests,
  sqlalchemy,
  sqlalchemy-file,
  sqlalchemy-utils,
  sqlmodel,
  starlette,
}:

buildPythonPackage rec {
  pname = "starlette-admin";
  version = "0.14.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jowilf";
    repo = "starlette-admin";
    rev = version;
    hash = "sha256-DoYD8Hc5pd68+BhASw3mwwCdhu0vYHiELjVmVwU8FHs=";
  };

  build-system = [ hatchling ];

  dependencies = [
    jinja2
    python-multipart
    starlette
  ];

  optional-dependencies = {
    i18n = [ babel ];
  };

  nativeCheckInputs = [
    aiosqlite
    arrow
    babel
    cacert
    colour
    fasteners
    httpx
    mongoengine
    motor
    passlib
    phonenumbers
    pillow
    psycopg2
    pydantic
    pytest-asyncio
    pytestCheckHook
    requests
    sqlalchemy
    sqlalchemy-file
    sqlalchemy-utils
    sqlmodel
  ];

  disabledTestPaths = [
    # odmantic is not packaged
    "tests/odmantic"
    # needs mongodb running on port 27017
    "tests/mongoengine"
  ];

  pythonImportsCheck = [
    "starlette_admin"
    "starlette_admin.actions"
    "starlette_admin.base"
    "starlette_admin.fields"
    "starlette_admin.i18n"
    "starlette_admin.tools"
    "starlette_admin.views"
  ];

  meta = with lib; {
    description = "Fast, beautiful and extensible administrative interface framework for Starlette & FastApi applications";
    homepage = "https://github.com/jowilf/starlette-admin";
    changelog = "https://github.com/jowilf/starlette-admin/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
  };
}
