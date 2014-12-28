{ stdenv, fetchurl, pythonPackages }:

pythonPackages.buildPythonPackage rec {
  name = "awscli-${version}";
  version = "1.6.10";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/aws/aws-cli/archive/${version}.tar.gz";
    sha256 = "1g25yqxpcjrwjiibwgjrlqdyx6hpdlcb6zr2s05w592gr9gpbwpm";
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

  meta = {
    homepage = https://aws.amazon.com/cli/;
    description = "Unified tool to manage your AWS services";
    license = stdenv.lib.licenses.asl20;
    maintainers = with stdenv.lib.maintainers; [ muflax ];
  };
}
