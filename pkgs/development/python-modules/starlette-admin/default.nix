{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  itsdangerous,
  jinja2,
  python-multipart,
  starlette,

  # optional-dependencies
  aiobotocore,
  babel,
  email-validator,
  nh3,
  reportlab,

  # tests
  arrow,
  boto3,
  httpx2,
  markdown,
  minio,
  mongoengine,
  openpyxl,
  pillow,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  sqlalchemy,
  sqlalchemy-file,
  sqlalchemy-utils,
  tablib,
  testcontainers,
  tinydb,
}:

buildPythonPackage rec {
  pname = "starlette-admin";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jowilf";
    repo = "starlette-admin";
    tag = version;
    hash = "sha256-Gc5CGQhJx55BJmbcxDO8M5JpQULWtXQqQv/9+7J0X6A=";
  };

  build-system = [ hatchling ];

  dependencies = [
    itsdangerous
    jinja2
    python-multipart
    starlette
  ];

  optional-dependencies = {
    email = [ email-validator ];
    i18n = [ babel ];
    pdf = [ reportlab ];
    s3 = [ aiobotocore ];
    tinymce = [ nh3 ];
  };

  nativeCheckInputs = [
    aiobotocore
    arrow
    babel
    boto3
    email-validator
    httpx2
    markdown
    minio
    mongoengine
    openpyxl
    pillow
    pydantic
    pytest-asyncio
    pytestCheckHook
    sqlalchemy
    sqlalchemy-file
    sqlalchemy-utils
    tablib
    testcontainers
    tinydb
    reportlab
  ]
  ++ tablib.optional-dependencies.all;

  # exclude cookicutter tests
  pytestFlags = [ "tests/" ];

  disabledTests = [
    # requires docker
    "test_build_response_with_file_field_returns_zip"
    "test_storage_save_returns_file_info"
    "test_storage_save_never_overwrites"
    "test_storage_delete_is_idempotent"
    "test_storage_url_contains_key"
    "test_storage_serve_returns_response"
    "test_storage_serve_returns_response"
    "test_s3_presigned_url"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # flaky, depends on test order
    "test_ensuring_pk"
    # flaky, of-by-one
    "test_api"
  ];

  disabledTestPaths = [
    # not packaged
    "tests/unit/beanie"
    "tests/unit/tortoise"
    # slow, requires a huge build closure
    "tests/integration"
    # requires various services running or docker
    "tests/e2e"
  ];

  pythonImportsCheck = [
    "starlette_admin"
    "starlette_admin.actions"
    "starlette_admin.auth"
    "starlette_admin.base"
    "starlette_admin.converters"
    "starlette_admin.cookies"
    "starlette_admin.events"
    "starlette_admin.exceptions"
    "starlette_admin.export"
    "starlette_admin.fields"
    "starlette_admin.filters"
    "starlette_admin.flash"
    "starlette_admin.i18n"
    "starlette_admin.routing"
    "starlette_admin.security"
    "starlette_admin.storage"
    "starlette_admin.theme"
    "starlette_admin.tools"
    "starlette_admin.views"
  ];

  meta = {
    description = "Fast, beautiful and extensible administrative interface framework for Starlette & FastApi applications";
    homepage = "https://github.com/jowilf/starlette-admin";
    changelog = "https://jowilf.github.io/starlette-admin/changelog/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pbsds ];
  };
}
