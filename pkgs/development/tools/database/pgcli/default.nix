{ lib
, stdenv
, buildPythonApplication
, fetchPypi
, isPy3k
, cli-helpers
, click
, configobj
, humanize
, prompt-toolkit
, psycopg2
, pygments
, sqlparse
, pgspecial
, setproctitle
, keyring
, pendulum
, pytestCheckHook
, mock
, sshtunnel
}:

buildPythonApplication rec {
  pname = "pgcli";
  version = "3.4.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1WbG7amarRonaAvf10ZX4lvAWG0E6vCxYmu1i951z7Y=";
  };

  propagatedBuildInputs = [
    cli-helpers
    click
    configobj
    humanize
    prompt-toolkit
    psycopg2
    pygments
    sqlparse
    pgspecial
    setproctitle
    keyring
    pendulum
    sshtunnel
  ];

  checkInputs = [ pytestCheckHook mock ];

  disabledTests = lib.optionals stdenv.isDarwin [ "test_application_name_db_uri" ];

  meta = with lib; {
    description = "Command-line interface for PostgreSQL";
    longDescription = ''
      Rich command-line interface for PostgreSQL with auto-completion and
      syntax highlighting.
    '';
    homepage = "https://pgcli.com";
    changelog = "https://github.com/dbcli/pgcli/raw/v${version}/changelog.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dywedir ];
  };
}
