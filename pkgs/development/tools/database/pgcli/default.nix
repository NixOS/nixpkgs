{ buildPythonApplication, lib, fetchPypi, isPy3k, fetchpatch
, cli-helpers, click, configobj, humanize, prompt_toolkit, psycopg2
, pygments, sqlparse, pgspecial, setproctitle, keyring, pytest, mock
}:

buildPythonApplication rec {
  pname = "pgcli";
  version = "3.0.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "10j01bd031fys1vcihibsi5rrfd8w1kgahpcsbk4l07871c24829";
  };

  propagatedBuildInputs = [
    cli-helpers click configobj humanize prompt_toolkit psycopg2
    pygments sqlparse pgspecial setproctitle keyring
  ];

  patches = [
    (fetchpatch {
      name = "enable-sqlparse-4.patch";
      url = "https://github.com/dbcli/pgcli/pull/1224/commits/55d534d41051887c637b6300e08a9f70e6656020.patch";
      sha256 = "01r8qc7qzb6mz0xq2xnrgyackbapf43ng6l88qpzd9lw2pwksc8w";
      includes = [ "pgcli/packages/parseutils/ctes.py" "tests/test_sqlcompletion.py" "setup.py" ];
    })
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
    homepage = "https://pgcli.com";
    license = licenses.bsd3;
    maintainers = with maintainers; [ dywedir ];
  };
}
