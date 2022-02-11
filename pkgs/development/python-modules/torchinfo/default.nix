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
  version = "1.6.3";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-g1xhtdwygzPTTswP8iZ364ynBQE7D+aAsZ3d9EpyvIA=";
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
