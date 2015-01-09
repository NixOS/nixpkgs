{ stdenv, fetchzip, pythonPackages, groff }:

pythonPackages.buildPythonPackage rec {
  name = "awscli-${version}";
  version = "1.7.0";
  namePrefix = "";

  src = fetchzip {
    url = "https://github.com/aws/aws-cli/archive/${version}.tar.gz";
    sha256 = "14cbfvwx18vs2l8hhvamy1mbvjwa3xrm58l8yyalhrh5pqq952mi";
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
