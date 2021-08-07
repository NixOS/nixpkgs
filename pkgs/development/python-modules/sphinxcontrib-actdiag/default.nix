{ lib
, buildPythonPackage
, fetchPypi
, sphinx
, actdiag
, blockdiag
}:

buildPythonPackage rec {
  pname = "sphinxcontrib-actdiag";
  version = "2.0.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TtuFZOLkig4MULLndDQlrTTx8RiGw34MsjmXoPladMY=";
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
