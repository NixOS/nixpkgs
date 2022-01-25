{ lib, stdenv
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
}:

buildPythonApplication rec {
  pname = "pgcli";
  version = "3.3.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/MyeVcpopK0Ih6z6KZGvs7ivk/PM6a2iSeatiYeZM6E=";
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
