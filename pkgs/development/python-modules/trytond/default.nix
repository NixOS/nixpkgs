{ lib
, buildPythonApplication
, fetchPypi
, pythonOlder
, mock
, lxml
, relatorio
, genshi
, python-dateutil
, polib
, python-sql
, werkzeug
, wrapt
, passlib
, pillow
, bcrypt
, pydot
, python-Levenshtein
, simplejson
, html2text
, psycopg2
, withPostgresql ? true
}:

buildPythonApplication rec {
  pname = "trytond";
  version = "6.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9494016dd8b4da5a06dccdd1afbd918248d42da9f2c19b1eb8958052c747e193";
  };

  # Tells the tests which database to use
  DB_NAME = ":memory:";

  buildInputs = [
    mock
  ];

  propagatedBuildInputs = [
    lxml
    relatorio
    genshi
    python-dateutil
    polib
    python-sql
    werkzeug
    wrapt
    pillow
    passlib

    # extra dependencies
    bcrypt
    pydot
    python-Levenshtein
    simplejson
    html2text
  ] ++ lib.optional withPostgresql psycopg2;

  # If unset, trytond will try to mkdir /homeless-shelter
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = with lib; {
    description = "The server of the Tryton application platform";
    longDescription = ''
      The server for Tryton, a three-tier high-level general purpose
      application platform under the license GPL-3 written in Python and using
      PostgreSQL as database engine.

      It is the core base of a complete business solution providing
      modularity, scalability and security.
    '';
    homepage = "http://www.tryton.org/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ udono johbo ];
  };
}
