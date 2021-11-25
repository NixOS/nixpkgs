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
  version = "3.2.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "6cde97e71996bf910a40b579e5285483c10ea04962a08def01c12433d5f7c6b7";
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

  disabledTests = [
    # tests that expect output from an older version of cli-helpers
    "test_format_output"
    "test_format_output_auto_expand"
  ] ++ lib.optionals stdenv.isDarwin [ "test_application_name_db_uri" ];

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
