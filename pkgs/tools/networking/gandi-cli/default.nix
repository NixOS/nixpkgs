{ stdenv, python3Packages, fetchFromGitHub }:

with python3Packages;

buildPythonApplication rec {
  pname = "gandi-cli";
  version = "1.5";

  src = fetchFromGitHub {
    owner = "Gandi";
    repo = "gandi.cli";
    rev = version;
    sha256 = "1jcabpphlm6qajw8dz0h4gynm03g1mxi0cn900i3v7wdfww1gfab";
  };

  propagatedBuildInputs = [ click ipy pyyaml requests ];

  doCheck = false;    # Tests try to contact the actual remote API

  meta = with stdenv.lib; {
    description = "Command-line interface to the public Gandi.net API";
    homepage = "https://cli.gandi.net/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kampka ];
  };
}
