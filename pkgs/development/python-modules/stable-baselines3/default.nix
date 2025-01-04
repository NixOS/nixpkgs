{
  lib,
  ale-py,
  buildPythonPackage,
  cloudpickle,
  fetchFromGitHub,
  gymnasium,
  matplotlib,
  numpy,
  opencv4,
  pandas,
  pillow,
  psutil,
  pygame,
  pytestCheckHook,
  pythonOlder,
  rich,
  setuptools,
  tensorboard,
  torch,
  tqdm,
}:
buildPythonPackage rec {
  pname = "stable-baselines3";
  version = "2.3.2-unstable-2024-11-04";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "DLR-RM";
    repo = "stable-baselines3";
    # commit with updated dependencies since gymnasium is not compatible with the latest release:
    # https://github.com/DLR-RM/stable-baselines3/pull/1837
    rev = "8f0b488bc5a897f1ac2b95f493bcb6b7e92d311c";
    hash = "sha256-zhmNZ86lowFJKes3i/TBBBsO8ZMuUUQsphQ98IsmHd4=";
  };

  pythonRelaxDeps = true;

  build-system = [ setuptools ];

  dependencies = [
    ale-py
    cloudpickle
    gymnasium
    matplotlib
    numpy
    opencv4
    pandas
    pillow
    psutil
    pygame
    rich
    tensorboard
    torch
    tqdm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    torch
  ];

  pythonImportsCheck = [ "stable_baselines3" ];

  disabledTestPaths = [
    # Tests starts training a model, which takes too long
    "tests/test_cnn.py"
    "tests/test_dict_env.py"
    "tests/test_her.py"
    "tests/test_save_load.py"
  ];

  disabledTests = [
    # Tests that attempt to access the filesystem
    "test_make_atari_env"
    "test_vec_env_monitor_kwargs"
  ];

  meta = {
    description = "PyTorch version of Stable Baselines, reliable implementations of reinforcement learning algorithms";
    homepage = "https://github.com/DLR-RM/stable-baselines3";
    # changelog = "https://github.com/DLR-RM/stable-baselines3/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ derdennisop ];
  };
}
