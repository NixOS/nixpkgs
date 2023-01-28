{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, python-dateutil
, duckdb
}:
buildPythonPackage rec {
  pname = "sqlglot";
  version = "6.0.7";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    repo = "sqlglot";
    owner = "tobymao";
    rev = "v${version}";
    hash = "sha256-7PBhf9NN/mCi92xSkB9ygfmfxTyOYaEyrNvL309sG5Y=";
  };

  propagatedBuildInputs = [ python-dateutil ];

  nativeCheckInputs = [ pytestCheckHook duckdb ];

  pythonImportsCheck = [ "sqlglot" ];

  meta = with lib; {
    description = "A no dependency Python SQL parser, transpiler, and optimizer";
    homepage = "https://github.com/tobymao/sqlglot";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
