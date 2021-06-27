{ lib
, buildPythonPackage
, fetchPypi
, sphinx
, blockdiag
, nwdiag
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-nwdiag";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bula1DutRv6NwfZRhciZfLHRZmXu42p+qvbeExN/+Fk=";
  };

  propagatedBuildInputs = [ sphinx blockdiag nwdiag ];

  pythonImportsCheck = [ "sphinxcontrib.nwdiag" ];

  meta = with lib; {
    description = "Sphinx nwdiag extension";
    homepage = "https://github.com/blockdiag/sphinxcontrib-nwdiag";
    maintainers = with maintainers; [ davidtwco ];
    license = licenses.bsd2;
  };
}
