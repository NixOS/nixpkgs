{
  lib,
  stdenv,
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
buildPythonPackage (finalAttrs: {
  pname = "stable-baselines3";
  version = "2.9.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "DLR-RM";
    repo = "stable-baselines3";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vKbILFjQuD2gAkl3J3RA/vEo5UYqWttJ99kZdlEsqkY=";
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

    # gymnasium.error.DeprecatedEnv: Environment version v3 for `Taxi` is deprecated.
    # Please use `Taxi-v4` instead.
    "tests/test_spaces.py::test_discrete_obs_space[Taxi-v3-A2C]"
    "tests/test_spaces.py::test_discrete_obs_space[Taxi-v3-DQN]"
    "tests/test_spaces.py::test_discrete_obs_space[Taxi-v3-PPO]"
  ];

  disabledTests = [
    # Flaky: Can fail if it takes too long, which happens when the system is under heavy load
    "test_fps_logger"

    # Tests that attempt to access the filesystem
    "test_make_atari_env"
    "test_vec_env_monitor_kwargs"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # RuntimeError: *** -[__NSPlaceholderArray initWithObjects:count:]: attempt to insert nil object from objects[1]
    "test_report_figure_to_tensorboard"
    "test_unsupported_figure_format"
  ];

  meta = {
    description = "PyTorch version of Stable Baselines, reliable implementations of reinforcement learning algorithms";
    homepage = "https://github.com/DLR-RM/stable-baselines3";
    changelog = "https://github.com/DLR-RM/stable-baselines3/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ derdennisop ];
  };
})
