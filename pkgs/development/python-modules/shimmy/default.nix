{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  wheel,
  gymnasium,
  numpy,
  ale-py,
  bsuite,
  dm-control,
  gym,
  imageio,
  pettingzoo,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "shimmy";
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Farama-Foundation";
    repo = "Shimmy";
    rev = "refs/tags/v${version}";
    hash = "sha256-rYBbGyMSFF/iIGruKn2JXKAVIZIfJDEHUEZUESiUg/k=";
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    gymnasium
    numpy
  ];

  pythonImportsCheck = [ "shimmy" ];

  nativeCheckInputs = [
    ale-py
    bsuite
    dm-control
    gym
    imageio
    pettingzoo
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Requires unpackaged pyspiel
    "tests/test_openspiel.py"

    # Broken since ale-py v0.9.0 due to API change
    # https://github.com/Farama-Foundation/Shimmy/issues/120
    "tests/test_atari.py"
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  disabledTests = [
    # Require network access
    "test_check_env[bsuite/mnist_noise-v0]"
    "test_check_env[bsuite/mnist_scale-v0]"
    "test_check_env[bsuite/mnist-v0]"
    "test_existing_env"
    "test_loading_env"
    "test_pickle[bsuite/mnist-v0]"
    "test_seeding[bsuite/mnist_noise-v0]"
    "test_seeding[bsuite/mnist_scale-v0]"
    "test_seeding[bsuite/mnist-v0]"
    "test_seeding"

    # RuntimeError: std::exception
    "test_check_env"
    "test_seeding[dm_control/quadruped-escape-v0]"
    "test_rendering_camera_id"
    "test_rendering_multiple_cameras"
    "test_rendering_depth"
    "test_render_height_widths"
  ];

  meta = {
    changelog = "https://github.com/Farama-Foundation/Shimmy/releases/tag/v${version}";
    description = "API conversion tool for popular external reinforcement learning environments";
    homepage = "https://github.com/Farama-Foundation/Shimmy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
