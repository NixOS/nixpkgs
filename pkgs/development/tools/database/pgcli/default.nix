{ lib, pythonPackages, fetchFromGitHub }:

pythonPackages.buildPythonApplication rec {
  name = "pgcli-${version}";
  version = "1.6.0";

  src = fetchFromGitHub {
    sha256 = "0f1zv4kwi2991pclf8chrhgjwf8jkqxdh5ndc9qx6igh56iyyncz";
    rev = "v${version}";
    repo = "pgcli";
    owner = "dbcli";
  };

  buildInputs = with pythonPackages; [ pytest mock ];
  checkPhase = ''
    mkdir /tmp/homeless-shelter
    HOME=/tmp/homeless-shelter py.test tests -k 'not test_missing_rc_dir and not test_quoted_db_uri and not test_port_db_uri'
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
