{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  matplotlib,
  pytest,
  scipy,
}:

buildPythonPackage rec {
  pname = "tadasets";
  version = "0.2.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PWbq+dCQ8mGR81lolBDSArxjkTdis1ZpLY0MqZfZ66I=";
  };

  propagatedBuildInputs = [
    numpy
    matplotlib
  ];

  nativeCheckInputs = [
    pytest
    scipy
  ];

<<<<<<< HEAD
  meta = {
    description = "Great data sets for Topological Data Analysis";
    homepage = "https://tadasets.scikit-tda.org";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "Great data sets for Topological Data Analysis";
    homepage = "https://tadasets.scikit-tda.org";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
