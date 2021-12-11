{ lib
, buildPythonPackage
, fetchPypi
, sphinx
, blockdiag
, seqdiag
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-seqdiag";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-QH5IeXZz9x2Ujp/6BHFsrB2ZqeyPYW3jdk1C0DNBZXQ=";
  };

  propagatedBuildInputs = [ sphinx blockdiag seqdiag ];

  pythonImportsCheck = [ "sphinxcontrib.seqdiag" ];

  meta = with lib; {
    description = "Sphinx seqdiag extension";
    homepage = "https://github.com/blockdiag/sphinxcontrib-seqdiag";
    maintainers = with maintainers; [ davidtwco ];
    license = licenses.bsd2;
  };
}
