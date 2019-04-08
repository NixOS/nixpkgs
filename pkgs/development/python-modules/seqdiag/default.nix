{ stdenv, fetchurl, buildPythonPackage, pep8, nose, unittest2, docutils
, blockdiag
}:

buildPythonPackage rec {
  pname = "seqdiag";
  version = "0.9.6";
  name = pname + "-" + version;

  src = fetchurl {
    url = "mirror://pypi/s/seqdiag/${name}.tar.gz";
    sha256 = "78104e7644c1a4d3a5cacb68de6a7f720793f08dd78561ef0e9e80bed63702bf";
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
