{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchNpmDeps,
  hatchling,
  gradio-client,
  huggingface-hub,
  nodejs,
  npmHooks,
  numpy,
  orjson,
  pillow,
  python-multipart,
  starlette,
  tomli,
  uvicorn,
  psutil,
  playwright,
  pytest,
  pytest-playwright,
  ruff,
  nvidia-ml-py,
  mcp,
  pyarrow,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "trackio";
  version = "0.26.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "gradio-app";
    repo = "trackio";
    tag = "trackio@${finalAttrs.version}";
    hash = "sha256-d2eWN+7lAlcnQwc5RVZvFlYv2CDhEPXZ329al5Rg44g=";
  };

  npmDeps = fetchNpmDeps {
    src = "${finalAttrs.src}/trackio/frontend";
    hash = "sha256-q1XMYwmQOULuReHnMdeRT4xzd4WOVsll6xdzv2UMgI8=";
  };
  env.SKIP_FRONTEND_BUILD = "1";
  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    npmHooks.npmBuildHook
  ];
  npmRoot = "trackio/frontend";

  build-system = [
    hatchling
  ];

  dependencies = [
    gradio-client
    huggingface-hub
    numpy
    orjson
    pillow
    python-multipart
    starlette
    tomli
    uvicorn
  ];

  optional-dependencies = {
    apple-gpu = [
      psutil
    ];
    dev = [
      playwright
      pytest
      pytest-playwright
      ruff
    ];
    gpu = [
      nvidia-ml-py
      psutil
    ];
    mcp = [
      mcp
    ];
    spaces = [
      pyarrow
    ];
  };

  pythonImportsCheck = [
    "trackio"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "A lightweight, local-first, and 🆓 experiment tracking library from Hugging Face";
    homepage = "https://github.com/gradio-app/trackio";
    changelog = "https://github.com/gradio-app/trackio/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bileam ];
  };
})
