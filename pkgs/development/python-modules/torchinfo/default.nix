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
  version = "1.64";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "TylerYep";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-gcl8RxCD017FP4LtB60WVtOh7jg2Otv/vNd9hKneEAU=";
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
