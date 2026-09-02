{
  lib,

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
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "viser-project";
    repo = "viser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N7Ry+KQagT/PTNsUtxVmEdKv4zgMIFOEgaYr1OwdYoM=";
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
    hash = "sha256-D96EWBs2yOHeJGsyiU+QWDP9KcteQZRQkssnNh8g//c=";
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
    zstandard
  ];

  optional-dependencies = {
    urdf = [ yourdfpy ];
    dev = [
      hypothesis
      nodeenv
      playwright
      pre-commit
      psutil
      pyright
      pytest
      pytest-playwright
      pytest-xdist
      ruff
    ]
    ++ finalAttrs.passthru.optional-dependencies.examples;
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
    ]
    ++ finalAttrs.passthru.optional-dependencies.urdf;
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

  pythonRelaxDeps = [
    # rich<15.0.0,>=13.3.3 not satisfied by version 15.0.0
    "rich"
    # trimesh<5.0.0,>=3.21.7 not satisfied by version 5.0.0
    "trimesh"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    changelog = "https://github.com/viser-project/viser/releases/tag/${finalAttrs.src.tag}";
    description = "Web-based 3D visualization in Python";
    homepage = "https://github.com/viser-project/viser";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
