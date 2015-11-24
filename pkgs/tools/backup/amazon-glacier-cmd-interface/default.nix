{ stdenv, fetchFromGitHub, buildPythonPackage, pythonPackages, python }:

buildPythonPackage rec {
  name     = "amazon-glacier-cmd-interface-${version}";
  version  = "2014-01-30";
  disabled = python.executable == "pypy"; # will not build for pypy

  src = fetchFromGitHub {
    owner  = "uskudnik";
    repo   = "amazon-glacier-cmd-interface";
    rev    = "cd642612c5870c4cb0d2232863e8dd75e3b1d399";
    sha256 = "1h2cbcc81gyqdzvdf1616gk3lzy3bzqfr06h1zb4pqqbnxixyh0r";
  };

  meta = {
    description = "Command line interface for Amazon Glacier";
    homepage    = https://github.com/uskudnik/amazon-glacier-cmd-interface;
    license     = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.lovek323 ];
  };

  propagatedBuildInputs = with pythonPackages; [
    argparse
    boto
    dateutil
    prettytable
    pytz
  ];
}
