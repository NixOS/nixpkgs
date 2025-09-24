{
  lib,

  buildPythonPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  nodejs,
  fetchYarnDeps,
  yarnConfigHook,

  # build-system
  hatchling,

  # dependencies
  imageio,
  msgspec,
  nodeenv,
  numpy,
  opencv-python,
  plyfile,
  psutil,
  requests,
  rich,
  scikit-image,
  scipy,
  tqdm,
  trimesh,
  typing-extensions,
  websockets,
  yourdfpy,

  # optional-dependencies
  hypothesis,
  pre-commit,
  pandas,
  pyright,
  pytest,
  ruff,
  gdown,
  matplotlib,
  plotly,
  # pyliblzfse,
  robot-descriptions,
  torch,
  tyro,

  # nativeCheckInputs
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "viser";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nerfstudio-project";
    repo = "viser";
    tag = "v${version}";
    hash = "sha256-AS5D6pco6wzQ414yxvv0K9FB3tfP1BvqigRLJJXDduU=";
  };

  postPatch = ''
    # prepare yarn offline cache
    mkdir -p node_modules
    cd src/viser/client
    cp package.json yarn.lock ../../..
    ln -s ../../../node_modules

    # fix: [vite-plugin-eslint] Failed to load config "react-app" to extend from.
    substituteInPlace vite.config.mts --replace-fail \
      "eslint({ failOnError: false, failOnWarning: false })," ""

    cd ../../..
  '';

  nativeBuildInputs = [
    yarnConfigHook
    nodejs
  ];

  yarnOfflineCache = fetchYarnDeps {
    yarnLock = src + "/src/viser/client/yarn.lock";
    hash = "sha256-4x+zJIqjVoKmEdOUPGpCuMmlRBfF++3oWtbNYAvd2ko=";
  };

  preBuild = ''
    cd src/viser/client
    yarn --offline build
    cd ../../..
  '';

  build-system = [
    hatchling
  ];

  dependencies = [
    imageio
    msgspec
    nodeenv
    numpy
    opencv-python
    plyfile
    psutil
    requests
    rich
    scikit-image
    scipy
    tqdm
    trimesh
    typing-extensions
    websockets
    yourdfpy
  ];

  optional-dependencies = {
    dev = [
      hypothesis
      pre-commit
      pyright
      pytest
      ruff
    ];
    examples = [
      gdown
      matplotlib
      pandas
      plotly
      plyfile
      # pyliblzfse
      robot-descriptions
      torch
      tyro
    ];
  };

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "viser"
  ];

  meta = {
    changelog = "https://github.com/nerfstudio-project/viser/releases/tag/${src.tag}";
    description = "Web-based 3D visualization + Python";
    homepage = "https://github.com/nerfstudio-project/viser";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
}
