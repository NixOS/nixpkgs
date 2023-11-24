{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, sphinx
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-katex";
  version = "0.9.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OmdUsc/JDhQeP3Pgg16vyCYtpfr+ekxnT6cI+rec69c=";
  };

  propagatedBuildInputs = [
    sphinx
  ];

  # There are no unit tests
  doCheck = false;

  pythonImportsCheck = [
    "sphinxcontrib.katex"
  ];

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "Sphinx extension using KaTeX to render math in HTML";
    homepage = "https://github.com/hagenw/sphinxcontrib-katex";
    changelog = "https://github.com/hagenw/sphinxcontrib-katex/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ jluttine ];
  };
}
