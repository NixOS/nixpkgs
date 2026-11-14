{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  loguru,
  mbstrdecoder,
  pytablewriter,
  setuptools,
  setuptools-scm,
  simplesqlite,
  sqliteschema,
  tabledata,
  typepy,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "sqliteschema";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "thombashi";
    repo = "sqliteschema";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZGDzGfj78v8o0GvAHcP26JiJCOWPaIr2h1Lqzh5AuSg=";
  };

  pythonRelaxDeps = [ "typepy" ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    mbstrdecoder
    tabledata
    typepy
  ];

  optional-dependencies = {
    cli =
      finalAttrs.passthru.optional-dependencies.dumps
      ++ finalAttrs.passthru.optional-dependencies.logging;
    dumps = [ pytablewriter ];
    logging = [ loguru ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    simplesqlite
    sqliteschema
  ]
  ++ finalAttrs.passthru.optional-dependencies.cli;

  pythonImportsCheck = [ "sqliteschema" ];

  # Enabling tests would trigger infinite recursion due to circular
  # dependency between this package and simplesqlite.
  # Therefore, we enable tests only when building passthru.tests.
  doCheck = false;
  passthru.tests.pytest = sqliteschema.overridePythonAttrs (_: {
    doCheck = true;
  });

  meta = {
    description = "Python library to dump table schema of a SQLite database file";
    homepage = "https://github.com/thombashi/sqliteschema";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ henrirosten ];
  };
})
