{
  lib,
  blockdiag,
  buildPythonPackage,
  fetchPypi,
  nwdiag,
  pythonOlder,
  sphinx,
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-nwdiag";
  version = "2.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bula1DutRv6NwfZRhciZfLHRZmXu42p+qvbeExN/+Fk=";
  };

  propagatedBuildInputs = [
    blockdiag
    nwdiag
    sphinx
  ];

  pythonImportsCheck = [ "sphinxcontrib.nwdiag" ];

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "Sphinx nwdiag extension";
    homepage = "https://github.com/blockdiag/sphinxcontrib-nwdiag";
    license = licenses.bsd2;
    maintainers = with maintainers; [ davidtwco ];
  };
}
