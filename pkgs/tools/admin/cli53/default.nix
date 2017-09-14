{ lib, python2, fetchurl }:

python2.pkgs.buildPythonApplication rec {
  name = "cli53-${version}";
  version = "0.4.4";

  src = fetchurl {
    url = "mirror://pypi/c/cli53/${name}.tar.gz";
    sha256 = "0s9jzigq6a16m2c3qklssx2lz16cf13g5zh80vh24kxazaxqzbig";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "'argparse', " ""
  '';

  checkPhase = ''
    ${python2.interpreter} -m unittest discover -s tests
  '';

  # Tests do not function
  doCheck = false;

  propagatedBuildInputs = with python2.pkgs; [
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
