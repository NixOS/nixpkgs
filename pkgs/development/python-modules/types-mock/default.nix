{ lib
, buildPythonPackage
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "types-mock";
  version = "5.1.0.20240106";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-E8o3nVcQzLPxj2mt5bCIgYdMuDOD2PtJsdTaydXF0JA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "Type stub package for the mock package";
    homepage = "https://pypi.org/project/types-mock";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
