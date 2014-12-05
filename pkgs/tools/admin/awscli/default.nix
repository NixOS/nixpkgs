{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "awscli-${version}";
  version = "1.5.5";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/aws/aws-cli/archive/${version}.tar.gz";
    sha256 = "1xqaav4g07jzv8i4hkf52dimgmc0zv0fj9rbvz5kiln8470qzifw";
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
