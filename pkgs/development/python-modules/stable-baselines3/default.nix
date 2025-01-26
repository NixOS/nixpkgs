{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  cloudpickle,
  gymnasium,
  matplotlib,
  numpy,
  pandas,
  torch,

  # tests
  ale-py,
  pytestCheckHook,
  rich,
  tqdm,
}:
buildPythonPackage rec {
  pname = "stable-baselines3";
  # TODO: To this date, the latest release (2.4.1) is not compatible with numpy 2 and does not build
  # successfully on nixpkgs
  version = "2.4.1-unstable-2025-01-07";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DLR-RM";
    repo = "stable-baselines3";
    rev = "b7c64a1aa4dd2fd3efed96e7a9ddb4d1f5c96112";
    hash = "sha256-oyTOBRZsKkhhGKwwBN9HCV0t8+MkJYpWsTRdS+upMeI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cloudpickle
    gymnasium
    matplotlib
    numpy
    pandas
    torch
  ];

  nativeCheckInputs = [
    ale-py
    pytestCheckHook
    rich
    tqdm
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
    changelog = "https://github.com/DLR-RM/stable-baselines3/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ derdennisop ];
  };
}
