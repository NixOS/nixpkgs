{ lib
, buildPythonPackage
, fetchPypi
, nose
, pandas
, matplotlib
}:

buildPythonPackage rec {
  pname = "seaborn";
  version = "0.7.1";
  name = "${pname}-${version}";
  src = fetchPypi {
    inherit pname version;
    sha256 = "0pawrqc3mxpwd5g9pvi9gba02637bh5c8ldpp8izfwpfn52469zs";
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