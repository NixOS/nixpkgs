{ stdenv, fetchurl, buildPythonPackage, isPy27, pep8, nose, unittest2, docutils
, blockdiag
}:

buildPythonPackage rec {
  pname = "seqdiag";
  version = "2.0.0";
  disabled = isPy27;

  src = fetchurl {
    url = "mirror://pypi/s/seqdiag/${pname}-${version}.tar.gz";
    sha256 = "0k7j4f9j3d0325piwvbv90nfh0wzfk2n6s73s6h6nsxmqshcgswk";
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
    platforms = platforms.unix;
    maintainers = with maintainers; [ bjornfor ];
  };
}
