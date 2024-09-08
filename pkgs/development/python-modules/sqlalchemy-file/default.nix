{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  fasteners,
  libcloud,
  pillow,
  pytestCheckHook,
  sqlalchemy,
  sqlmodel,
}:

buildPythonPackage rec {
  pname = "sqlalchemy-file";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jowilf";
    repo = "sqlalchemy-file";
    rev = version;
    hash = "sha256-gtW7YA/rQ48tnqPdypMnSqqtwb90nhAkiQNhgEr1M3I=";
  };

  build-system = [ hatchling ];

  dependencies = [
    libcloud
    sqlalchemy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    fasteners
    pillow
    sqlmodel
  ];

  preCheck = ''
    # used in get_test_container in tests/utils.py
    # fixes FileNotFoundError: [Errno 2] No such file or directory: '/tmp/storage/...'
    mkdir .storage
    export LOCAL_PATH="$PWD/.storage"
  '';

  disabledTestPaths = lib.optionals stdenv.isDarwin [
    # very flaky, sandbox issues?
    # libcloud.storage.types.ContainerDoesNotExistError
    # sqlite3.OperationalError: attempt to write a readonly database
    "tests/test_content_type_validator.py"
    "tests/test_image_field.py"
    "tests/test_image_validator.py"
    "tests/test_metadata.py"
    "tests/test_multiple_field.py"
    "tests/test_multiple_storage.py"
    "tests/test_processor.py"
    "tests/test_single_field.py"
    "tests/test_size_validator.py"
    "tests/test_sqlmodel.py"
  ];

  pythonImportsCheck = [
    "sqlalchemy_file"
    "sqlalchemy_file.file"
    "sqlalchemy_file.types"
    "sqlalchemy_file.helpers"
  ];

  meta = with lib; {
    description = "SQLAlchemy extension for attaching files to SQLAlchemy model and uploading them to various storage with Apache Libcloud";
    homepage = "https://github.com/jowilf/sqlalchemy-file";
    changelog = "https://github.com/jowilf/sqlalchemy-file/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
  };
}
