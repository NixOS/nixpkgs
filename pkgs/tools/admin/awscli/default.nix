{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "awscli-${version}";
  version = "0.8.3";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/aws/aws-cli/archive/${version}.tar.gz";
    sha256 = "0v7igh00zja560v8qz315g3m7x9six1hprrrb10cpp9sy8n58xnn";
  };

  propagatedBuildInputs = [ 
    pythonPackages.argparse
    pythonPackages.botocore
    pythonPackages.colorama
  ];
}
