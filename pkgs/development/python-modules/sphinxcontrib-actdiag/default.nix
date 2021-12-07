{ lib
, buildPythonPackage
, fetchPypi
, sphinx
, actdiag
, blockdiag
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-actdiag";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PFXUVP/Due/nwg8q2vAiGZuCVhLTLyAL6KSXqofg+B8=";
  };

  propagatedBuildInputs = [ sphinx actdiag blockdiag ];

  pythonImportsCheck = [ "sphinxcontrib.actdiag" ];

  meta = with lib; {
    description = "Sphinx actdiag extension";
    homepage = "https://github.com/blockdiag/sphinxcontrib-actdiag";
    maintainers = with maintainers; [ davidtwco ];
    license = licenses.bsd2;
  };
}
