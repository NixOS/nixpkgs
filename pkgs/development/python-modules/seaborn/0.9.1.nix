{ lib
, buildPythonPackage
, fetchPypi
, nose
, pandas
, matplotlib
}:

buildPythonPackage rec {
  pname = "seaborn";
  version = "0.9.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "da33aa8c20a9a342ce73831d02831a10413f54a05471c7f31edf34f225d456ae";
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
    maintainers = [ ];
  };
}
