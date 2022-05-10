{ lib
, buildPythonPackage
, fetchFromGitHub
, cloudpickle
, scikit-learn
, scikitimage
, packaging
, psutil
, py-deprecate
, pytorch
, pytestCheckHook
, torchmetrics
, pytorch-lightning
}:

let
  pname = "torchmetrics";
  version = "0.8.1";
in
buildPythonPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "PyTorchLightning";
    repo = "metrics";
    rev = "v${version}";
    hash = "sha256-AryEhYAeC97dO2pgHoz0Y9F//DVdX6RfCa80gI56iz4=";
  };

  propagatedBuildInputs = [
    packaging
    py-deprecate
  ];

  # Let the user bring their own instance
  buildInputs = [
    pytorch
  ];

  checkInputs = [
    pytorch-lightning
    scikit-learn
    scikitimage
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

