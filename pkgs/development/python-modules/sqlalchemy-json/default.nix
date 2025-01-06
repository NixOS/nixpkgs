{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  sqlalchemy,
}:

let
  version = "0.7.0";
in
buildPythonPackage {
  pname = "sqlalchemy-json";
  inherit version;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "edelooff";
    repo = "sqlalchemy-json";
    tag = "v${version}";
    hash = "sha256-Is3DznojvpWYFSDutzCxRLceQMIiS3ZIg0c//MIOF+s=";
  };

  propagatedBuildInputs = [ sqlalchemy ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Full-featured JSON type with mutation tracking for SQLAlchemy";
    homepage = "https://github.com/edelooff/sqlalchemy-json";
    changelog = "https://github.com/edelooff/sqlalchemy-json/tree/v${version}#changelog";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ augustebaum ];
  };
}
