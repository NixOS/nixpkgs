{ stdenv, fetchzip, pythonPackages, groff }:

pythonPackages.buildPythonPackage rec {
  name = "awscli-${version}";
  version = "1.7.21";
  namePrefix = "";

  src = fetchzip {
    url = "https://github.com/aws/aws-cli/archive/${version}.tar.gz";
    sha256 = "1hm2m5ycsyn4lap8549d6glryp9b9mvar9xwbpmpdcf698lcxzsj";
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
