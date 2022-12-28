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
  version = "1.7.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "TylerYep";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-jiQ24gx3N9djvTTB6IthzxcuGWX2/php0Up3IdEDvm8=";
  };

  propagatedBuildInputs = [
    torch
    torchvision
  ];

  checkInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Skip as it downloads pretrained weights (require network access)
    "test_eval_order_doesnt_matter"
    # AssertionError in output
    "test_google"
  ];

  pythonImportsCheck = [
    "torchvision"
  ];

  meta = with lib; {
    description = "API to visualize pytorch models";
    homepage = "https://github.com/TylerYep/torchinfo";
    license = licenses.mit;
    maintainers = with maintainers; [ petterstorvik ];
  };
}
