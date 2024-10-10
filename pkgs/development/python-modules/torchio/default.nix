{
  stdenv,
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  deprecated,
  humanize,
  matplotlib,
  nibabel,
  numpy,
  parameterized,
  scipy,
  simpleitk,
  torch,
  tqdm,
  typer,
}:

buildPythonPackage rec {
  pname = "torchio";
  version = "0.20.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fepegar";
    repo = "torchio";
    rev = "refs/tags/v${version}";
    hash = "sha256-Soew23+Skpc2IpVBMuOnC5LBW0vFL/9LszLijkJgQoQ=";
  };

  propagatedBuildInputs = [
    deprecated
    humanize
    nibabel
    numpy
    scipy
    simpleitk
    torch
    tqdm
    typer
  ];

  nativeCheckInputs = [
    pytestCheckHook
    matplotlib
    parameterized
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

  meta = with lib; {
    description = "Medical imaging toolkit for deep learning";
    homepage = "https://torchio.readthedocs.io";
    license = licenses.asl20;
    maintainers = [ maintainers.bcdarwin ];
  };
}
