{ lib, python2Packages, fetchurl }:

python2Packages.buildPythonApplication rec {
  name = "cli53-${version}";
  version = "0.4.4";

  src = fetchurl {
    url = "mirror://pypi/c/cli53/${name}.tar.gz";
    sha256 = "0s9jzigq6a16m2c3qklssx2lz16cf13g5zh80vh24kxazaxqzbig";
  };

  propagatedBuildInputs = with python2Packages; [
    argparse
    boto
    dns
  ];

  meta = with lib; {
    description = "CLI tool for the Amazon Route 53 DNS service";
    homepage = https://github.com/barnybug/cli53;
    license = licenses.mit;
    maintainers = with maintainers; [ benley ];
  };
}
