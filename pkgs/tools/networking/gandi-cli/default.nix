{ stdenv, python3Packages, fetchFromGitHub }:

with python3Packages;

buildPythonApplication rec {
  pname = "gandi-cli";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "Gandi";
    repo = "gandi.cli";
    rev = version;
    sha256 = "06dc59iwxfncz61hs3lcq08c5zrp7x4n4ibk5lpqqx6rk0izzz9b";
  };

  propagatedBuildInputs = [ click ipy pyyaml requests ];

  doCheck = false;    # Tests try to contact the actual remote API

  meta = with stdenv.lib; {
    description = "Command-line interface to the public Gandi.net API";
    homepage = https://cli.gandi.net/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ckampka ];
  };
}
