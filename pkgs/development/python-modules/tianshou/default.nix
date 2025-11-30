{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  deepdiff,
  gymnasium,
  h5py,
  matplotlib,
  numba,
  numpy,
  overrides,
  packaging,
  pandas,
  pettingzoo,
  sensai-utils,
  tensorboard,
  torch,
  tqdm,

  # optional-dependencies
  docstring-parser,
  jsonargparse,
  ale-py,
  opencv,
  shimmy,
  pybox2d,
  pygame,
  swig,
  mujoco,
  imageio,
  cython,
  pybullet,
  joblib,
  scipy,

  # tests
  pymunk,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "tianshou";
  version = "1.2.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "thu-ml";
    repo = "tianshou";
    tag = "v${version}";
    hash = "sha256-lJAxjE+GMwssov1r4jOCOTf5Aonu+q6FSz5oWvZpuQQ=";
  };

  pythonRelaxDeps = [
    "deepdiff"
    "gymnasium"
    "numpy"
  ];

  pythonRemoveDeps = [ "virtualenv" ];

  postPatch = ''
    # silence matplotlib warning
    export MPLCONFIGDIR=$(mktemp -d)
  '';

  build-system = [ poetry-core ];

  dependencies = [
    deepdiff
    gymnasium
    h5py
    matplotlib
    numba
    numpy
    overrides
    packaging
    pandas
    pettingzoo
    sensai-utils
    tensorboard
    torch
    tqdm
  ];

  optional-dependencies = {
    all = lib.concatAttrValues (lib.removeAttrs optional-dependencies [ "all" ]);

    argparse = [
      docstring-parser
      jsonargparse
    ];

    atari = [
      ale-py
      # autorom
      opencv
      shimmy
    ];

    box2d = [
      # instead of box2d-py
      pybox2d
      pygame
      swig
    ];

    classic_control = [
      pygame
    ];

    mujoco = [
      mujoco
      imageio
      cython
    ];

    pybullet = [
      pybullet
    ];

    # envpool = [
    #   envpool
    # ];

    # robotics = [
    #   gymnasium-robotics
    # ];

    # vizdoom = [
    #   vizdoom
    # ];

    eval = [
      docstring-parser
      joblib
      jsonargparse
      # rliable
      scipy
    ];
  };

  pythonImportsCheck = [ "tianshou" ];

  nativeCheckInputs = [
    pygame
    pymunk
    pytestCheckHook
  ];

  disabledTestPaths = [
    # remove tests that require lot of compute (ai model training tests)
    "test/continuous"
    "test/discrete"
    "test/highlevel"
    "test/modelbased"
    "test/offline"
  ];

  disabledTests = [
    # AttributeError: 'TimeLimit' object has no attribute 'test_attribute'
    "test_attr_unwrapped"
    # Failed: DID NOT RAISE <class 'TypeError'>
    "test_batch"
    # Failed: Raised AssertionError
    "test_vecenv"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Fatal Python error: Aborted
    # pettingzoo/classic/tictactoe/tictactoe.py", line 254 in reset
    "test_tic_tac_toe"
  ];

  meta = {
    description = "Elegant PyTorch deep reinforcement learning library";
    homepage = "https://github.com/thu-ml/tianshou";
    changelog = "https://github.com/thu-ml/tianshou/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ derdennisop ];
  };
}
