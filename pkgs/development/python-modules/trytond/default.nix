{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
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
  withPostgresql ? true,
  psycopg2,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "trytond";
  version = "7.4.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4ThDDsAvy/9Md1bbOJatIZYzrhZQsMP4hbh/9MBUxgA=";
  };

  build-system = [ setuptools ];

  dependencies =
    [
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
    ]
    ++ relatorio.optional-dependencies.fodt
    ++ passlib.optional-dependencies.bcrypt
    ++ passlib.optional-dependencies.argon2
    ++ lib.optional withPostgresql psycopg2;

  nativeCheckInputs = [ unittestCheckHook ];

  preCheck = ''
    export HOME=$(mktemp -d)
    export TRYTOND_DATABASE_URI="sqlite://"
    export DB_NAME=":memory:";
  '';

  unittestFlagsArray = [
    "-s"
    "trytond.tests"
  ];

  meta = with lib; {
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
    license = licenses.gpl3Plus;
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = with maintainers; [
      udono
      johbo
    ];
  };
}
