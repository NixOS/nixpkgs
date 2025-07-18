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
  plyfile,
  psutil,
  rich,
  scikit-image,
  scipy,
  tqdm,
  trimesh,
  tyro,
  websockets,
  yourdfpy,

  # optional-dependencies
  hypothesis,
  pre-commit,
  pyright,
  pytest,
  ruff,
  gdown,
  matplotlib,
  opencv-python,
  plotly,
  # pyliblzfse,
  # robot-descriptions,
  torch,

  # nativeCheckInputs
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "viser";
  version = "0.2.23";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nerfstudio-project";
    repo = "viser";
    tag = "v${version}";
    hash = "sha256-c9Yxu4/OnHpJbLxluiaVK1RlFtsfaI++pYZpViU/HAQ=";
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
    hash = "sha256-o75aOQLl33W497oaNCkf5kYYlLLH4CNTe+Al6vdgLLM=";
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
    plyfile
    psutil
    rich
    scikit-image
    scipy
    tqdm
    trimesh
    tyro
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
      opencv-python
      plotly
      plyfile
      # pyliblzfse
      # robot-descriptions
      torch
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
