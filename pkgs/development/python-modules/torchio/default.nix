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
  jaxtyping,
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
  monai,
  pandas,
  ffmpeg-python,
  scikit-learn,

  # tests
  parameterized,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "torchio";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "TorchIO-project";
    repo = "torchio";
    tag = "v${version}";
    hash = "sha256-b6ED3IyQgC0A0dqYiXC0GTf6ZqwE1Ka7ojM7OJu1xfI=";
  };

  build-system = [
    uv-build
  ];

  dependencies = [
    deprecated
    einops
    humanize
    jaxtyping
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

  optional-dependencies =
    let
      extras = {
        csv = [ pandas ];
        monai = [ monai ];
        plot = [
          colorcet
          matplotlib
        ];
        video = [ ffmpeg-python ];
        sklearn = [ scikit-learn ];
      };
    in
    extras // { all = lib.concatLists (lib.attrValues extras); };

  nativeCheckInputs = [
    matplotlib
    parameterized
    pytestCheckHook
  ]
  ++ optional-dependencies.monai
  ++ optional-dependencies.sklearn;

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
    changelog = "https://github.com/TorchIO-project/torchio/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.bcdarwin ];
  };
}
