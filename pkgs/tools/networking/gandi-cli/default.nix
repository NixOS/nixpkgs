{ stdenv, pythonPackages, fetchFromGitHub }:

with pythonPackages;

buildPythonPackage rec {
  namePrefix = "";
  name = "gandi-cli-${version}";
  version = "0.19";

  src = fetchFromGitHub {
    sha256 = "0xbf97p75zl6sjxqcgmaa4p5rax2h6ixn8srwdr4rsx2zz9dpwgp";
    rev = version;
    repo = "gandi.cli";
    owner = "Gandi";
  };

  propagatedBuildInputs = [ click ipy pyyaml requests ];

  doCheck = false;    # Tests try to contact the actual remote API

  meta = with stdenv.lib; {
    description = "Command-line interface to the public Gandi.net API";
    homepage = http://cli.gandi.net/;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ nckx ];
  };
}

