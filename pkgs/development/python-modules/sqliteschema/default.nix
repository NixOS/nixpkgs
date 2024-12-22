{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  mbstrdecoder,
  setuptools,
  simplesqlite,
  sqliteschema,
  tabledata,
  typepy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sqliteschema";
  version = "1.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = "sqliteschema";
    rev = "v${version}";
    hash = "sha256-IzHdYBnh6udVsanWTPSsX4p4PG934YCdzs9Ow/NW86E=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    mbstrdecoder
    tabledata
    typepy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    simplesqlite
    sqliteschema
  ];

  pythonImportsCheck = [ "sqliteschema" ];

  # Enabling tests would trigger infinite recursion due to circular
  # dependency between this package and simplesqlite.
  # Therefore, we enable tests only when building passthru.tests.
  doCheck = false;
  passthru.tests.pytest = sqliteschema.overridePythonAttrs (_: {
    doCheck = true;
  });

  meta = with lib; {
    description = "Python library to dump table schema of a SQLite database file";
    homepage = "https://github.com/thombashi/sqliteschema";
    license = licenses.mit;
    maintainers = with maintainers; [ henrirosten ];
  };
}
