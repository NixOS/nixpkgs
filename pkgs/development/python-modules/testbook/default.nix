{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nbformat,
  nbclient,
  ipykernel,
  pandas,
  pytestCheckHook,
  setuptools,
  traitlets,
}:

buildPythonPackage rec {
  pname = "testbook";
  version = "0.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nteract";
    repo = "testbook";
    rev = version;
    hash = "sha256-qaDgae/5TRpjmjOf7aom7TC5HLHp0PHM/ds47AKtq8U=";
  };

  propagatedBuildInputs = [
    nbclient
    nbformat
  ];

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [
    ipykernel
    pandas
    pytestCheckHook
    traitlets
  ];

  pythonImportsCheck = [ "testbook" ];

  meta = {
    description = "Unit testing framework extension for testing code in Jupyter Notebooks";
    homepage = "https://testbook.readthedocs.io/";
    license = with lib.licenses; [ bsd3 ];
    maintainers = with lib.maintainers; [ djacu ];
  };
}
