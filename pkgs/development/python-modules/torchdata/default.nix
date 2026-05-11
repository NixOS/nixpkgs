{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cmake,
  ninja,
  setuptools,
  torch,

  # dependencies
  requests,
  urllib3,

  # tests
  datasets,
  parameterized,
  pytest-xdist,
  pytestCheckHook,
  pythonAtLeast,
}:

buildPythonPackage (finalAttrs: {
  pname = "torchdata";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "meta-pytorch";
    repo = "data";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TSkZLL4WDSacuX4tl0+1bKSJCRI3LEhAyU3ztdlUvgk=";
  };

  build-system = [
    cmake
    ninja
    setuptools
    torch
  ];
  dontUseCmakeConfigure = true;

  dependencies = [
    requests
    urllib3
  ];

  pythonImportsCheck = [ "torchdata" ];

  nativeCheckInputs = [
    datasets
    parameterized
    pytest-xdist
    pytestCheckHook
  ];

  disabledTests =
    lib.optionals (pythonAtLeast "3.14") [
      # _pickle.PicklingError: Can't pickle local object <...worker_set_affinity at 0x7ffbcfa1ba00>
      "test_set_affinity_in_worker_init"

      # RuntimeError: DataLoader timed out after 5 seconds
      "test_ind_worker_queue"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # RuntimeError: DataLoader timed out after 5 seconds
      "test_ind_worker_queue"
    ];

  meta = {
    description = "Iterative enhancement to the PyTorch torch.utils.data.DataLoader and torch.utils.data.Dataset/IterableDataset";
    homepage = "https://github.com/meta-pytorch/data";
    changelog = "https://github.com/meta-pytorch/data/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
