{ stdenv, fetchzip, pythonPackages, groff }:

pythonPackages.buildPythonPackage rec {
  name = "awscli-${version}";
  version = "1.7.29";
  namePrefix = "";

  src = fetchzip {
    url = "https://github.com/aws/aws-cli/archive/${version}.tar.gz";
    sha256 = "0r0w5qldimdp2d2ykw7pmppn8chbhh6cm48famhldqnyrh3vrf02";
  };

  propagatedBuildInputs = [
    pythonPackages.botocore
    pythonPackages.bcdoc
    pythonPackages.six
    pythonPackages.colorama
    pythonPackages.docutils
    pythonPackages.rsa
    pythonPackages.pyasn1
    groff
  ];

  meta = {
    homepage = https://aws.amazon.com/cli/;
    description = "Unified tool to manage your AWS services";
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ muflax ];
  };
}
