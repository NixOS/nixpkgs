{ lib
, buildPythonPackage
, fetchFromGitHub
, cloudpickle
, scikit-learn
, scikit-image
, packaging
, psutil
, py-deprecate
, torch
, pytestCheckHook
, torchmetrics
, pytorch-lightning
}:

let
  pname = "torchmetrics";
  version = "1.1.2";
in
buildPythonPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "PyTorchLightning";
    repo = "metrics";
    rev = "refs/tags/v${version}";
    hash = "sha256-qbO2POXJp2O0VL16zY5mb6TDpogs1L34anFVeSf502g=";
  };

  propagatedBuildInputs = [
    packaging
    py-deprecate
  ];

  # Let the user bring their own instance
  buildInputs = [
    torch
  ];

  nativeCheckInputs = [
    pytorch-lightning
    scikit-learn
    scikit-image
    cloudpickle
    psutil
    pytestCheckHook
  ];

  # A cyclic dependency in: integrations/test_lightning.py
  doCheck = false;
  passthru.tests.check = torchmetrics.overridePythonAttrs (_: {
    doCheck = true;
  });

  disabledTestPaths = [
    # These require too many "leftpad-level" dependencies
    "tests/text"
    "tests/audio"
    "tests/image"

    # A few non-deterministic things like test_check_compute_groups_is_faster
    "tests/bases/test_collections.py"
  ];

  pythonImportsCheck = [
    "torchmetrics"
  ];

  meta = with lib; {
    description = "Machine learning metrics for distributed, scalable PyTorch applications (used in pytorch-lightning)";
    homepage = "https://torchmetrics.readthedocs.io";
    license = licenses.asl20;
    maintainers = with maintainers; [
      SomeoneSerge
    ];
  };
}

