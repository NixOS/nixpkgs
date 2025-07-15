{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  deprecated,
  einops,
  matplotlib,
  nibabel,
  numpy,
  packaging,
  rich,
  scipy,
  simpleitk,
  torch,
  tqdm,
  typer,

  # tests
  humanize,
  parameterized,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "torchio";
  version = "0.20.17";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TorchIO-project";
    repo = "torchio";
    tag = "v${version}";
    hash = "sha256-kZCbQGIkWmlXl25UviPrSDo0swCjWnvTTkBnxGI0Y7U=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    deprecated
    einops
    humanize
    nibabel
    numpy
    packaging
    rich
    scipy
    simpleitk
    torch
    tqdm
    typer
  ];

  nativeCheckInputs = [
    matplotlib
    parameterized
    pytestCheckHook
  ];

  disabledTests =
    [
      # tries to download models:
      "test_load_all"
    ]
    ++ lib.optionals stdenv.hostPlatform.isAarch64 [
      # RuntimeError: DataLoader worker (pid(s) <...>) exited unexpectedly
      "test_queue_multiprocessing"
    ];

  pythonImportsCheck = [
    "torchio"
    "torchio.data"
  ];

  meta = {
    description = "Medical imaging toolkit for deep learning";
    homepage = "https://torchio.readthedocs.io";
    changelog = "https://github.com/TorchIO-project/torchio/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.bcdarwin ];
  };
}
