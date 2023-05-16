{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, defusedxml
, lxml
, relatorio
, genshi
, python-dateutil
, polib
, python-sql
, werkzeug
, wrapt
, passlib
, pydot
, levenshtein
, html2text
, weasyprint
, gevent
, pillow
, withPostgresql ? true
, psycopg2
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "trytond";
<<<<<<< HEAD
  version = "6.8.3";
=======
  version = "6.6.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-n0Fdu2IjdyAt9qJ40l9kVRbV8NMXU1R5aR+9rmXEgC8=";
=======
    hash = "sha256-pnFsIv7Rl6NHUV0ETqaN7UYQuRlV3G68F5p4gzHzihQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    defusedxml
    lxml
    relatorio
    genshi
    python-dateutil
    polib
    python-sql
    werkzeug
    wrapt
    passlib

    # extra dependencies
    pydot
    levenshtein
    html2text
    weasyprint
    gevent
    pillow
  ] ++ relatorio.optional-dependencies.fodt
  ++ passlib.optional-dependencies.bcrypt
  ++ passlib.optional-dependencies.argon2
  ++ lib.optional withPostgresql psycopg2;

  nativeCheckInputs = [ unittestCheckHook ];

  preCheck = ''
    export HOME=$(mktemp -d)
    export TRYTOND_DATABASE_URI="sqlite://"
    export DB_NAME=":memory:";
  '';

  unittestFlagsArray = [ "-s" "trytond.tests" ];

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
    changelog = "https://hg.tryton.org/trytond/file/${version}/CHANGELOG";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ udono johbo ];
  };
}
