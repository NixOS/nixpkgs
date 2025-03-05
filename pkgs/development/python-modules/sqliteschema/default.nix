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
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = "sqliteschema";
    tag = "v${version}";
    hash = "sha256-tLrdp99TifU3SwIOSIksJWepkFpZEfkf1lnSt6M2ylA=";
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
