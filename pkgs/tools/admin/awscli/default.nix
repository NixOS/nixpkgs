{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "awscli-${version}";
  version = "1.2.13";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/aws/aws-cli/archive/${version}.tar.gz";
    sha256 = "1mpy1q9y5qiq1fr2xc98sn1njx0p0b1g21p0rdh4ccsf9w7i0rpb";
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
