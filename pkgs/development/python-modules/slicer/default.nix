{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, pandas
, torch
, scipy
, setuptools
}:

buildPythonPackage rec {
  pname = "slicer";
  version = "0.0.8";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LnVTr3PwwMLTVfSvzD7Pl8byFW/PRZOVXD9Wz2xNbrc=";
  };

  build-system = [
    setuptools
  ];

  pythonImportsCheck = [
    "slicer"
  ];

  nativeCheckInputs = [ pytestCheckHook pandas torch scipy ];

  meta = with lib; {
    description = "Wraps tensor-like objects and provides a uniform slicing interface via __getitem__";
    homepage = "https://github.com/interpretml/slicer";
    license = licenses.mit;
    maintainers = with maintainers; [ evax ];
  };
}
