{ buildPythonApplication, lib, fetchPypi, isPy3k
, cli-helpers, click, configobj, humanize, prompt_toolkit, psycopg2
, pygments, sqlparse, pgspecial, setproctitle, keyring, pytest, mock
}:

buildPythonApplication rec {
  pname = "pgcli";
  version = "2.2.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "54138a31e6736a34c63b84a6d134c9292c9a73543cc0f66e80a0aaf79259d39b";
  };

  propagatedBuildInputs = [
    cli-helpers click configobj humanize prompt_toolkit psycopg2
    pygments sqlparse pgspecial setproctitle keyring
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "prompt_toolkit>=2.0.6,<3.0.0" "prompt_toolkit"
  '';

  checkInputs = [ pytest mock ];

  # `test_application_name_db_uri` fails: https://github.com/dbcli/pgcli/issues/1104
  checkPhase = ''
    pytest --deselect=tests/test_main.py::test_application_name_db_uri
  '';

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
