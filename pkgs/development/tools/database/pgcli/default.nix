{ lib, pythonPackages, fetchFromGitHub }:

pythonPackages.buildPythonApplication rec {
  name = "pgcli-${version}";
  version = "1.5.1";

  src = fetchFromGitHub {
    sha256 = "1wp8pzi9hwz16fpcr0mq3ffydwdscfg5whhzc91757dw995sgl0s";
    rev = "v${version}";
    repo = "pgcli";
    owner = "dbcli";
  };

  buildInputs = with pythonPackages; [ pytest mock ];
  checkPhase = ''
    py.test tests -k 'not test_missing_rc_dir and not test_quoted_db_uri and not test_port_db_uri'
  '';

  propagatedBuildInputs = with pythonPackages; [
    click configobj humanize prompt_toolkit psycopg2
    pygments sqlparse pgspecial setproctitle
  ];

  postPatch = ''
    substituteInPlace setup.py --replace "==" ">="
    rm tests/test_rowlimit.py
  '';

  meta = with lib; {
    description = "Command-line interface for PostgreSQL";
    longDescription = ''
      Rich command-line interface for PostgreSQL with auto-completion and
      syntax highlighting.
    '';
    homepage = https://pgcli.com;
    license = licenses.bsd3;
    maintainers = with maintainers; [ nckx ];
  };
}
