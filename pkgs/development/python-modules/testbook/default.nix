{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, nbformat
, nbclient
, ipykernel
, pandas
, pytestCheckHook
, traitlets
}:

buildPythonPackage rec {
  pname = "testbook";
  version = "0.4.2";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "nteract";
    repo = pname;
    rev = version;
    sha256 = "sha256-qaDgae/5TRpjmjOf7aom7TC5HLHp0PHM/ds47AKtq8U=";
  };

  propagatedBuildInputs = [
    nbclient
    nbformat
  ];

  checkInputs = [
    ipykernel
    pandas
    pytestCheckHook
    traitlets
  ];

  pythonImportsCheck = [
    "testbook"
  ];

  meta = with lib; {
    description = "A unit testing framework extension for testing code in Jupyter Notebooks";
    homepage = "https://testbook.readthedocs.io/";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ djacu ];
  };
}
