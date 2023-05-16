{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, python-dateutil
, duckdb
<<<<<<< HEAD
, setuptools-scm
}:
buildPythonPackage rec {
  pname = "sqlglot";
  version = "17.14.2";
=======
, pyspark
}:
buildPythonPackage rec {
  pname = "sqlglot";
  version = "10.5.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    repo = "sqlglot";
    owner = "tobymao";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-aImshQ5jf0k62ucpK4X8G7uHGAFQkhGgjMYo4mvSvew=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [ setuptools-scm ];

  # optional dependency used in the sqlglot optimizer
  propagatedBuildInputs = [ python-dateutil ];

  nativeCheckInputs = [ pytestCheckHook duckdb ];
=======
    hash = "sha256-ZFc2aOhCTRFlrzgnYDSdIZxRqKZ8FvkYSZRU0OMHI34=";
  };

  propagatedBuildInputs = [ python-dateutil ];

  nativeCheckInputs = [ pytestCheckHook duckdb pyspark ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # these integration tests assume a running Spark instance
  disabledTestPaths = [ "tests/dataframe/integration" ];

  pythonImportsCheck = [ "sqlglot" ];

  meta = with lib; {
    description = "A no dependency Python SQL parser, transpiler, and optimizer";
    homepage = "https://github.com/tobymao/sqlglot";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
  };
}
