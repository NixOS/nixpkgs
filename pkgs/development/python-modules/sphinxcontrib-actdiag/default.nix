{ lib
, buildPythonPackage
, fetchPypi
, sphinx
, actdiag
, blockdiag
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-actdiag";
  version = "3.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PFXUVP/Due/nwg8q2vAiGZuCVhLTLyAL6KSXqofg+B8=";
  };

  propagatedBuildInputs = [
    actdiag
    blockdiag
    sphinx
  ];

  pythonImportsCheck = [
    "sphinxcontrib.actdiag"
  ];

  pythonNamespaces = [ "sphinxcontrib" ];

  meta = with lib; {
    description = "Sphinx actdiag extension";
    homepage = "https://github.com/blockdiag/sphinxcontrib-actdiag";
    license = licenses.bsd2;
    maintainers = with maintainers; [ davidtwco ];
  };
}
