{ stdenv, fetchurl, buildPythonPackage, pythonPackages }:

buildPythonPackage rec {
  name = "ipython-0.11";
  namePrefix = "";

  src = fetchurl {
    url = "http://pypi.python.org/packages/source/i/ipython/${name}.tar.gz";
    md5 = "efc899e752a4a4a67a99575cea1719ef";
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
