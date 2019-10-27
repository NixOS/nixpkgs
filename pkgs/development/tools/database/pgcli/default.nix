{ buildPythonApplication, lib, fetchPypi, isPy3k, fetchpatch
, cli-helpers, click, configobj, humanize, prompt_toolkit, psycopg2
, pygments, sqlparse, pgspecial, setproctitle, keyring, pytest, mock
}:

buildPythonApplication rec {
  pname = "pgcli";
  version = "2.1.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1jmnb8izsdjmq9cgajhfapr31wlhvcml4lakz2mcmjn355x83q44";
  };

  propagatedBuildInputs = [
    cli-helpers click configobj humanize prompt_toolkit psycopg2
    pygments sqlparse pgspecial setproctitle keyring
  ];

  checkInputs = [ pytest mock ];

  # One test fails: https://github.com/dbcli/pgcli/issues/1104
  doCheck = false;
  checkPhase = "pytest";

  meta = with lib; {
    description = "Command-line interface for PostgreSQL";
    longDescription = ''
      Rich command-line interface for PostgreSQL with auto-completion and
      syntax highlighting.
    '';
    homepage = https://pgcli.com;
    license = licenses.bsd3;
    maintainers = with maintainers; [ dywedir ];
  };
}
