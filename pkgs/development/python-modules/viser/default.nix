{
  lib,

  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  nodejs,
  fetchNpmDeps,
  npmHooks,

  # build-system
  hatchling,

  # dependencies
  imageio,
  msgspec,
  numpy,
  requests,
  rich,
  tqdm,
  trimesh,
  typing-extensions,
  websockets,
  yourdfpy,
  zstandard,

  # optional-dependencies
  hypothesis,
  liblzfse,
  nodeenv,
  opencv-python,
  playwright,
  pre-commit,
  psutil,
  pyright,
  pytest,
  pytest-playwright,
  pytest-xdist,
  ruff,
  gdown,
  matplotlib,
  pandas,
  plotly,
  plyfile,
  robot-descriptions,
  torch,
  tyro,

  # nativeCheckInputs
  pytestCheckHook,
  playwright-driver,
}:

buildPythonPackage (finalAttrs: {
  pname = "viser";
  version = "1.0.28";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "viser-project";
    repo = "viser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-M9zLL3CGvEErcWj2V0iRIlBV+HtfhWQAK4Dd8V118h0=";
  };

  postPatch = ''
    # prepare npm offline cache
    mkdir -p node_modules
    cd src/viser/client
    cp package.json package-lock.json ../../..
    ln -s ../../../node_modules
    cd ../../..
  '';

  nativeBuildInputs = [
    npmHooks.npmConfigHook
    nodejs
  ];

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    src = finalAttrs.src + "/src/viser/client/";
    hash = "sha256-fAFN/JCUVSvRDGfq39E3V+dhqp1i6vFG/j8wKmOva4c=";
  };

  preBuild = ''
    cd src/viser/client
    npm --offline run build
    cd ../../..
  '';

  build-system = [
    hatchling
  ];

  dependencies = [
    imageio
    msgspec
    numpy
    requests
    rich
    tqdm
    trimesh
    typing-extensions
    websockets
    yourdfpy
    zstandard
  ];

  optional-dependencies = {
    dev = [
      hypothesis
      nodeenv
      opencv-python
      playwright
      pre-commit
      psutil
      pyright
      pytest
      pytest-playwright
      pytest-xdist
      ruff
    ];
    examples = [
      gdown
      liblzfse
      matplotlib
      opencv-python
      pandas
      plotly
      plyfile
      robot-descriptions
      torch
      tyro
    ];
  };

  nativeCheckInputs = [
    hypothesis
    playwright-driver
    pytestCheckHook
  ];

  # adding pre-commit here break PYTHONPATH in 3.14
  checkInputs = lib.filter (p: p.pname != "pre-commit") finalAttrs.passthru.optional-dependencies.dev;

  env = {
    PLAYWRIGHT_BROWSERS_PATH = playwright-driver.browsers;
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = true;
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = true;
  };

  disabledTestPaths = [
    # too many flaky tests
    "tests/e2e"
  ];
  disabledTests = [
    # assert 0 != 0
    # (only when xdist)
    "test_server_port_is_freed"

    # counts ffmpeg pids, can be confused when
    # building multiple times this package in parallel
    "test_process_termination"
  ];

  pythonImportsCheck = [
    "viser"
  ];

  meta = {
    changelog = "https://github.com/viser-project/viser/releases/tag/${finalAttrs.src.tag}";
    description = "Web-based 3D visualization in Python";
    homepage = "https://github.com/viser-project/viser";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
