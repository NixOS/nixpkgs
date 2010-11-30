{ stdenv, fetchurl, buildPythonPackage }:

buildPythonPackage {
  name = "ipython-0.10.1";

  src = fetchurl {
    url = "http://ipython.scipy.org/dist/0.10.1/ipython-0.10.1.tar.gz";
    sha256 = "18zwrg25zn72w4rmcwxzcw11ibgp001fawm2sz189zv86z70fxi2";
  };

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
