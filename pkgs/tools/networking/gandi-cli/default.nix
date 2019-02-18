{ stdenv, python3Packages, fetchFromGitHub }:

with python3Packages;

buildPythonApplication rec {
  pname = "gandi-cli";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "Gandi";
    repo = "gandi.cli";
    rev = version;
    sha256 = "07i1y88j5awsw7qadk7gnmax8mi7vgh1nflnc8j54z53fjyamlcs";
  };

  propagatedBuildInputs = [ click ipy pyyaml requests ];

  doCheck = false;    # Tests try to contact the actual remote API

  meta = with stdenv.lib; {
    description = "Command-line interface to the public Gandi.net API";
    homepage = http://cli.gandi.net/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ckampka ];
  };
}
