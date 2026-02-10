{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  defusedxml,
  lxml,
  relatorio,
  genshi,
  python-dateutil,
  polib,
  python-sql,
  werkzeug,
  passlib,
  pydot,
  levenshtein,
  html2text,
  weasyprint,
  gevent,
  pillow,
  pwdlib,
  simpleeval,
  withPostgresql ? true,
  psycopg2,
  unittestCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "trytond";
  version = "7.8.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-F2sb3JgbNjbmgS5o9vUCWOBgII4Vv2E8Ml6ijTQA8D8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    defusedxml
    lxml
    relatorio
    genshi
    python-dateutil
    polib
    python-sql
    werkzeug
    passlib

    # extra dependencies
    pydot
    levenshtein
    html2text
    weasyprint
    gevent
    pillow
    pwdlib
    simpleeval
  ]
  ++ relatorio.optional-dependencies.fodt
  ++ passlib.optional-dependencies.bcrypt
  ++ passlib.optional-dependencies.argon2
  ++ lib.optional withPostgresql psycopg2;

  # Fontconfig error: Cannot load default config file: No such file: (null)
  doCheck = false;

  nativeCheckInputs = [
    unittestCheckHook
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    export TRYTOND_DATABASE_URI="sqlite://"
    export DB_NAME=":memory:";
  '';

  unittestFlagsArray = [
    "-s"
    "trytond.tests"
  ];

  meta = {
    description = "Server of the Tryton application platform";
    longDescription = ''
      The server for Tryton, a three-tier high-level general purpose
      application platform under the license GPL-3 written in Python and using
      PostgreSQL as database engine.

      It is the core base of a complete business solution providing
      modularity, scalability and security.
    '';
    homepage = "http://www.tryton.org/";
    changelog = "https://foss.heptapod.net/tryton/tryton/-/blob/trytond-${version}/trytond/CHANGELOG?ref_type=tags";
    license = lib.licenses.gpl3Plus;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with lib.maintainers; [
      udono
      johbo
    ];
  };
}
