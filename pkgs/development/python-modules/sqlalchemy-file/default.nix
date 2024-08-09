{
  lib,
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

  nativeBuildInputs = [ hatchling ];

  propagatedBuildInputs = [
    libcloud
    sqlalchemy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    fasteners
    pillow
    sqlmodel
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
