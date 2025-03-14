{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  setuptools,

  # dependencies
  gymnasium,
  numpy,

  # tests
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
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Farama-Foundation";
    repo = "Shimmy";
    tag = "v${version}";
    hash = "sha256-/wIXjOGb3UeMQdeifYagd7OcxbBcdGPS09mjvkFsWmk=";
  };

  patches = [
    # Shimmy tries to register some environments from `dm-control` that require unpackaged `labmaze`.
    # This prevents from importing `shimmy` itself by crashing with a `ModuleNotFoundError`.
    # This patch imports those environments lazily.
    #
    # TODO: get rid of this patch at the next release as the issue has been fixed upstream:
    # https://github.com/Farama-Foundation/Shimmy/pull/125
    (fetchpatch {
      name = "prevent-labmaze-import-crash";
      url = "https://github.com/Farama-Foundation/Shimmy/commit/095d576f6aae15a09a1e426138629ce9f43a3c04.patch";
      hash = "sha256-rr9l3tHunYFk0j7hfo9IaSRlogAtwXoXcQ0zuU/TL8c=";
    })
  ];

  build-system = [
    setuptools
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
    # Requires unpackaged labmaze
    "tests/test_dm_control_multi_agent.py"

    # Requires unpackaged pyspiel
    "tests/test_openspiel.py"
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
