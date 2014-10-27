{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "awscli-${version}";
  version = "1.5.3";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/aws/aws-cli/archive/${version}.tar.gz";
    sha256 = "058lc4qj4xkjha9d1b5wrk2ca3lqfb9b45sb7czv0k1nwc0fciq1";
  };

  propagatedBuildInputs = [ 
    pythonPackages.botocore
    pythonPackages.bcdoc
    pythonPackages.six
    pythonPackages.colorama
    pythonPackages.docutils
    pythonPackages.rsa
    pythonPackages.pyasn1
  ];
}
