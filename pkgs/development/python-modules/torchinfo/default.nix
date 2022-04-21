{ lib
, fetchPypi
, python
, buildPythonPackage
, pythonOlder
, pytorch
, pytestCheckHook
, torchvision
}:

buildPythonPackage rec {
  pname = "torchinfo";
  version = "1.6.5";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Vg/TXD+/VMIv1wHywaOuEj4MDTq90lUo99n+Nppu0uI=";
  };

  propagatedBuildInputs = [
    pytorch
    torchvision
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Skip as it downloads pretrained weights (require network access)
    "test_eval_order_doesnt_matter"
  ];

  pythonImportsCheck = [ "torchvision" ];

  meta = {
    description = "API to visualize pytorch models";
    homepage = "https://github.com/TylerYep/torchinfo";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ petterstorvik ];
  };
}
