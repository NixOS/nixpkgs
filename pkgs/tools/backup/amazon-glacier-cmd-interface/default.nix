{ stdenv, fetchFromGitHub, python2Packages  }:

python2Packages.buildPythonApplication rec {
  name     = "amazon-glacier-cmd-interface-${version}";
  version  = "2016-09-01";

  src = fetchFromGitHub {
    owner  = "uskudnik";
    repo   = "amazon-glacier-cmd-interface";
    rev    = "9f28132f9872e1aad9e956e5613b976504e930c8";
    sha256 = "1k5z8kda9v6klr4536pf5qbq9zklxvyysv7nc48gllschl09jywc";
  };

  # argparse is part of the standardlib
  prePatch = ''
    substituteInPlace setup.py --replace "'argparse'," ""
  '';

  propagatedBuildInputs = with python2Packages; [
    boto
    dateutil
    prettytable
    pytz
  ];

  meta = {
    description = "Command line interface for Amazon Glacier";
    homepage    = https://github.com/uskudnik/amazon-glacier-cmd-interface;
    license     = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.lovek323 ];
  };

}
