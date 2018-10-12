{ lib, pythonPackages, fetchFromGitHub }:

pythonPackages.buildPythonApplication rec {
  name = "pgcli-${version}";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "dbcli";
    repo = "pgcli";
    rev = "v${version}";
    sha256 = "01qcvl0iwabinq3sb4340js8v3sbwkbxi64sg4xy76wj8xr6kgsk";
  };

  buildInputs = with pythonPackages; [ pytest mock ];
  checkPhase = ''
    mkdir /tmp/homeless-shelter
    HOME=/tmp/homeless-shelter py.test tests -k 'not test_missing_rc_dir and not test_quoted_db_uri and not test_port_db_uri'
  '';

  propagatedBuildInputs = with pythonPackages; [
    cli-helpers click configobj humanize prompt_toolkit psycopg2
    pygments sqlparse pgspecial setproctitle keyring
  ];

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
