{ lib
, buildPythonPackage
, fetchPypi
, nose
, pandas
, matplotlib
}:

buildPythonPackage rec {
  pname = "seaborn";
  version = "0.9.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "76c83f794ca320fb6b23a7c6192d5e185a5fcf4758966a0c0a54baee46d41e2f";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [ pandas matplotlib ];

  checkPhase = ''
    nosetests -v
  '';

  # Computationally very demanding tests
  doCheck = false;

  meta = {
    description = "Statisitical data visualization";
    homepage = "http://stanford.edu/~mwaskom/software/seaborn/";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ fridh ];
  };
}