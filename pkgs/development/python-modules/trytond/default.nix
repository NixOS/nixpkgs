{ stdenv
, buildPythonApplication
, fetchPypi
, pythonOlder
, mock
, lxml
, relatorio
, genshi
, dateutil
, polib
, python-sql
, werkzeug
, wrapt
, passlib
, bcrypt
, pydot
, python-Levenshtein
, simplejson
, html2text
, psycopg2
, withPostgresql ? true
}:

with stdenv.lib;

buildPythonApplication rec {
  pname = "trytond";
  version = "5.8.0";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ae9baf7a83a3249686703eee71e81a0283570f545ce985a999fd74b6ab3d4e4f";
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
    dateutil
    polib
    python-sql
    werkzeug
    wrapt
    passlib

    # extra dependencies
    bcrypt
    pydot
    python-Levenshtein
    simplejson
    html2text
  ] ++ stdenv.lib.optional withPostgresql psycopg2;

  # If unset, trytond will try to mkdir /homeless-shelter
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  meta = {
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
