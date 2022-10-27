{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-katex";
  version = "0.9.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HFs1+9tWl1D5VWY14dPCk+Ewv+ubedhd9DcCSrPQZnQ=";
  };

  propagatedBuildInputs = [
    sphinx
  ];

  # There are no unit tests
  doCheck = false;

  pythonImportsCheck = [
    "sphinxcontrib.katex"
  ];

  meta = with lib; {
    description = "Sphinx extension using KaTeX to render math in HTML";
    homepage = "https://github.com/hagenw/sphinxcontrib-katex";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
