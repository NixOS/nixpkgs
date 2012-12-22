{ stdenv, fetchurl, buildPythonPackage, pythonPackages }:

buildPythonPackage rec {
  name = "ipython-0.13";
  namePrefix = "";

  src = fetchurl {
    url = "http://pypi.python.org/packages/source/i/ipython/${name}.tar.gz";
    sha256 = "1m4m0zf3llnicfgrbnl2h08p3662px7v2pzbhq4fq24vnyz6x5w2";
  };

  propagatedBuildInputs = [ pythonPackages.readline pythonPackages.sqlite3 ];

  doCheck = false;

  meta = {
    homepage = http://ipython.scipy.org/;
    description = "An interactive computing environment for Python";
    license = "BSD";

    longDescription = ''
      The goal of IPython is to create a comprehensive environment
      for interactive and exploratory computing. It consists of an
      enhanced interactive Python shell and an architecture for
      interactive parallel computing.
    '';
  };
}
