{ stdenv, fetchurl, buildPythonPackage, pythonPackages }:

buildPythonPackage rec {
  name = "ipython-0.13.1";
  namePrefix = "";

  src = fetchurl {
    url = "http://pypi.python.org/packages/source/i/ipython/${name}.tar.gz";
    sha256 = "1h7q2zlyfn7si2vf6gnq2d0krkm1f5jy5nbi105by7zxqjai1grv";
  };

  propagatedBuildInputs = [ pythonPackages.readline pythonPackages.sqlite3 pythonPackages.tornado pythonPackages.pyzmq ];

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
