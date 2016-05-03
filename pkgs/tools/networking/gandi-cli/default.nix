{ stdenv, pythonPackages, fetchFromGitHub }:

with pythonPackages;

buildPythonPackage rec {
  namePrefix = "";
  name = "gandi-cli-${version}";
  version = "0.18";

  src = fetchFromGitHub {
    sha256 = "045gnz345nfbi1g7j3gcyzrxrx3hcidaxzr05cb49rcr8nmqh1s3";
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

