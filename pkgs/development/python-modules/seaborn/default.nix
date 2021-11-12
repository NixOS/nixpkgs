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
  version = "0.11.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cf45e9286d40826864be0e3c066f98536982baf701a7caa386511792d61ff4f6";
  };

  checkInputs = [ nose ];
  propagatedBuildInputs = [ pandas matplotlib ];

  checkPhase = ''
    nosetests -v
  '';

  # Computationally very demanding tests
  doCheck = false;
  pythonImportsCheck= [ "seaborn" ];

  meta = {
    description = "Statisitical data visualization";
    homepage = "https://seaborn.pydata.org/";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ fridh ];
  };
}
