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
  version = "2.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DLR-RM";
    repo = "stable-baselines3";
    tag = "v${version}";
    hash = "sha256-VnoQ8cKqPcZPpR9c3M6xJDdG7gnO9fxIa4v2kxd9Nzg=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [
    "gymnasium"
  ];

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
    # Flaky: Can fail if it takes too long, which happens when the system is under heavy load
    "test_fps_logger"

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
