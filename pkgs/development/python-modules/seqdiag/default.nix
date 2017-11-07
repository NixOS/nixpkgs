{ stdenv, fetchurl, buildPythonPackage, pep8, nose, unittest2, docutils
, blockdiag
}:

buildPythonPackage rec {
  name = "seqdiag-0.9.4";

  src = fetchurl {
    url = "mirror://pypi/s/seqdiag/${name}.tar.gz";
    sha256 = "1qa7d0m1wahvmrj95rxkb6128cbwd4w3gy8gbzncls66h46bifiz";
  };

  buildInputs = [ pep8 nose unittest2 docutils ];

  propagatedBuildInputs = [ blockdiag ];

  # Tests fail:
  #   ...
  #   ERROR: Failure: OSError ([Errno 2] No such file or directory: '/tmp/nix-build-python2.7-seqdiag-0.9.0.drv-0/seqdiag-0.9.0/src/seqdiag/tests/diagrams/')
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Generate sequence-diagram image from spec-text file (similar to Graphviz)";
    homepage = http://blockdiag.com/;
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor ];
  };
}
