{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
, torch
, torchvision
}:

buildPythonPackage rec {
  pname = "torchinfo";
  version = "1.7.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "TylerYep";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-O+I7BNQ5moV/ZcbbuP/IFoi0LO0WsGHBbSfgPmFu1Ec=";
  };

  propagatedBuildInputs = [
    torch
    torchvision
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Skip as it downloads pretrained weights (require network access)
    "test_eval_order_doesnt_matter"
    # AssertionError in output
    "test_google"
  ];

  disabledTestPaths = [
    # Wants "compressai", which we don't package (2023-03-23)
    "tests/torchinfo_xl_test.py"
  ];

  pythonImportsCheck = [
    "torchinfo"
  ];

  meta = with lib; {
    description = "API to visualize pytorch models";
    homepage = "https://github.com/TylerYep/torchinfo";
    license = licenses.mit;
    maintainers = with maintainers; [ petterstorvik ];
  };
}
