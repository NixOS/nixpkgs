{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  uv-build,

  # dependencies
  deprecated,
  einops,
  humanize,
  nibabel,
  numpy,
  packaging,
  rich,
  scipy,
  simpleitk,
  torch,
  tqdm,
  typer,

  # optional dependencies
  colorcet,
  matplotlib,
  pandas,
  ffmpeg-python,
  scikit-learn,

  # tests
  parameterized,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "torchio";
  version = "0.20.23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TorchIO-project";
    repo = "torchio";
    tag = "v${version}";
    hash = "sha256-OSqXV8aINqi7MstUy4RfIWLH4NxJB+r1tdzMrSgo7pg=";
  };

  build-system = [
    uv-build
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

  optional-dependencies = {
    csv = [ pandas ];
    plot = [
      colorcet
      matplotlib
    ];
    video = [ ffmpeg-python ];
    sklearn = [ scikit-learn ];
  };

  nativeCheckInputs = [
    matplotlib
    parameterized
    pytestCheckHook
  ];

  disabledTests = [
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
    homepage = "https://docs.torchio.org";
    changelog = "https://github.com/TorchIO-project/torchio/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.bcdarwin ];
  };
}
