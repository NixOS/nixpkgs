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
  version = "0.11.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "44e78eaed937c5a87fc7a892c329a7cc091060b67ebd1d0d306b446a74ba01ad";
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
    homepage = "https://seaborn.pydata.org/";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ fridh ];
  };
}
