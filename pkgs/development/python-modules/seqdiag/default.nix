{ stdenv, fetchurl, buildPythonPackage, pep8, nose, unittest2, docutils
, blockdiag
}:

buildPythonPackage rec {
  pname = "seqdiag";
  version = "0.9.5";
  name = pname + "-" + version;

  src = fetchurl {
    url = "mirror://pypi/s/seqdiag/${name}.tar.gz";
    sha256 = "994402cb19fef77ee113d18810aa397a7290553cda5f900be2bb44e2c7742657";
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
