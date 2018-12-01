{ lib, python3Packages, fetchFromGitHub }:

python3Packages.buildPythonApplication rec {
  pname = "pgcli";
  version = "2.0.1";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "149naq3gp1n922vag7vixs0hd114bpbmbmv70k4kzc1q7jz748l2";
  };

  propagatedBuildInputs = with python3Packages; [
    cli-helpers click configobj humanize prompt_toolkit psycopg2
    pygments sqlparse pgspecial setproctitle keyring
  ];

  checkInputs = with python3Packages; [ pytest mock ];

  checkPhase = ''
    py.test
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
