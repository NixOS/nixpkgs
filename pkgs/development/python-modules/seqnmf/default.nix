{ lib
, buildPythonPackage
, fetchPypi
, numpy
, matplotlib
, scipy
, seaborn
}:

buildPythonPackage rec {
  pname = "seqnmf";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "75a7bdb5f23de6345625f0d36bb0e42399f270ebe0d411d5a6ee64f6e7325f51";
  };

  propagatedBuildInputs = [
    numpy
    matplotlib
    scipy
    seaborn
  ];

  # no tests
  doCheck=false;

  meta = with lib; {
    description = "Python implementation of seqNMF";
    homepage = https://www.context-lab.com;
    license = licenses.mit;
    maintainers = [ maintainers.tbenst ];
  };
}