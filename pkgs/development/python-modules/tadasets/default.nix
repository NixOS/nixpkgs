{ lib
, buildPythonPackage
, fetchPypi
, numpy
, matplotlib
, pytest
, scipy
}:

buildPythonPackage rec {
  pname = "tadasets";
  version = "0.0.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a0e6c14678750315febd97fcf334bbbfd2695ebd91b4fe7707bb1220d7348416";
  };

  propagatedBuildInputs = [
    numpy
    matplotlib
  ];

  nativeCheckInputs = [
    pytest
    scipy
  ];

  meta = with lib; {
    description = "Great data sets for Topological Data Analysis";
    homepage = "https://tadasets.scikit-tda.org";
    license = licenses.mit;
    maintainers = [ ];
  };
}
