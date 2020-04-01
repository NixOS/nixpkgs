{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, nose
, pandas
, matplotlib
}:

buildPythonPackage rec {
  pname = "seaborn";
  version = "0.10.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "59fe414e138d7d5ea08b0feb01b86caf4682e36fa748e3987730523a89aecbb9";
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
