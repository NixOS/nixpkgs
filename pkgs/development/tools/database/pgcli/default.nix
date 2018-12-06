{ lib, pythonPackages, fetchFromGitHub }:

pythonPackages.buildPythonApplication rec {
  pname = "pgcli";
  version = "2.0.0";

  src = pythonPackages.fetchPypi {
    inherit pname version;
    sha256 = "085fna5nc72nfj1gw0m4ia6wzayinqaffmjy3ajldha1727vqwzi";
  };

  propagatedBuildInputs = with pythonPackages; [
    cli-helpers click configobj humanize prompt_toolkit psycopg2
    pygments sqlparse pgspecial setproctitle keyring
  ];

  checkInputs = with pythonPackages; [ pytest mock ];

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
