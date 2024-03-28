{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
, pyphen
}:

buildPythonPackage rec {
  version = "0.7.3";
  pname = "textstat";
  disabled = pythonOlder "3.6";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YLY8+JSfRbuztCBeRBG7wc1m30wIrvElRYEcfm4k8BE=";
  };

  propagatedBuildInputs = [
    setuptools
    pyphen
  ];

  pythonImportsCheck = [
    "textstat"
  ];

  meta = with lib; {
    description = "Python package to calculate readability statistics of a text object";
    homepage = "https://textstat.org";
    license = licenses.mit;
    maintainers = with maintainers; [ aleksana ];
  };
}
