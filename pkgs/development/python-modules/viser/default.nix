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
  gdown,
  liblzfse,
  matplotlib,
  opencv-python,
  pandas,
  plotly,
  plyfile,
  robot-descriptions,
  torch,
  tyro,

  # tests
  hypothesis,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "viser";
  version = "1.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "viser-project";
    repo = "viser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jf1/BJpkHxt5teR0ay1YKvCdsC6QFApFPuQswPjPW4g=";
  };

  npmRoot = "src/viser/client";
  npmDeps = fetchNpmDeps {
    inherit (finalAttrs) pname version src;
    sourceRoot = "${finalAttrs.src.name}/${finalAttrs.npmRoot}";
    hash = "sha256-ebEJ4lm45L6+Dw1jh0BjciUEQWpFNGqfVMT6loIgZsk=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
  ];

  preBuild = ''
    pushd ${finalAttrs.npmRoot}
    npm --offline run build
    popd
  '';

  build-system = [
    hatchling
  ];

  pythonRelaxDeps = [
    # rich<15.0.0,>=13.3.3 not satisfied by version 15.0.0
    "rich"
    # websockets<17.0.0,>=13.1 not satisfied by version 17.0.1
    "websockets"
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

  pythonImportsCheck = [ "viser" ];

  nativeCheckInputs = [
    hypothesis
    opencv-python
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Require a browser (playwright)
    "tests/e2e"
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
