{ lib, buildPythonApplication, pythonPackages, fetchurl }:

buildPythonApplication rec {
  name = "cli53-${version}";
  namePrefix = "";  # Suppress "python27-" name prefix
  version = "0.4.4";

  src = fetchurl {
    url = "https://pypi.python.org/packages/source/c/cli53/${name}.tar.gz";
    sha256 = "0s9jzigq6a16m2c3qklssx2lz16cf13g5zh80vh24kxazaxqzbig";
  };

  propagatedBuildInputs = with pythonPackages; [
    argparse
    boto
    dns
  ];

  meta = {
    description = "CLI tool for the Amazon Route 53 DNS service";
    homepage = https://github.com/barnybug/cli53;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ benley ];
  };
}
