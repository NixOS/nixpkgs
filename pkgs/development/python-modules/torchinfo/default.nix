{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, pythonOlder
, torch
, torchvision
, pytestCheckHook
, transformers
}:

buildPythonPackage rec {
  pname = "torchinfo";
  version = "1.8.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "TylerYep";
    repo = "torchinfo";
    rev = "refs/tags/v${version}";
    hash = "sha256-pPjg498aT8y4b4tqIzNxxKyobZX01u+66ScS/mee51Q=";
  };

  patches = [
    (fetchpatch {  # Add support for Python 3.11 and pytorch 2.1
      url = "https://github.com/TylerYep/torchinfo/commit/c74784c71c84e62bcf56664653b7f28d72a2ee0d.patch";
      hash = "sha256-xSSqs0tuFpdMXUsoVv4sZLCeVnkK6pDDhX/Eobvn5mw=";
      includes = [
        "torchinfo/model_statistics.py"
      ];
    })
  ];

  propagatedBuildInputs = [
    torch
    torchvision
  ];

  nativeCheckInputs = [
    pytestCheckHook
    transformers
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # Skip as it downloads pretrained weights (require network access)
    "test_eval_order_doesnt_matter"
    "test_flan_t5_small"
    # AssertionError in output
    "test_google"
    # "addmm_impl_cpu_" not implemented for 'Half'
    "test_input_size_half_precision"
  ];

  disabledTestPaths = [
    # Test requires network access
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
