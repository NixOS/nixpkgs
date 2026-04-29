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
  version = "1.0.26";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "viser-project";
    repo = "viser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qmHgjXBTJB0ka+QM+wmiUIXS+upeH3MxjAU9wHePWMY=";
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
    hash = "sha256-pV8xc+dQA8Z2EpQoIxzUlH2cZJoGKB03cP6GglGdn58=";
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

  checkInputs = finalAttrs.passthru.optional-dependencies.dev;

  env = {
    PLAYWRIGHT_BROWSERS_PATH = playwright-driver.browsers;
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = true;
    PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = true;
  };

  disabledTests = [
    # AssertionError: Locator expected to be visible
    "test_modal_renders_with_content[chromium]"
    "test_rgb_color_picker_renders[chromium]"
    "test_rgb_server_update[chromium]"
    "test_rgba_color_picker_renders[chromium]"
    "test_vector2_renders[chromium]"
    "test_vector2_initial_values[chromium]"
    "test_vector3_renders[chromium]"
    "test_vector3_server_update[chromium]"
    "test_slider_renders[chromium]"
    "test_text_input_renders_with_value[chromium]"
    "test_number_input_renders[chromium]"
    "test_dropdown_renders[chromium]"
    "test_dropdown_with_initial_value[chromium]"
    "test_markdown_renders[chromium]"
    "test_folder_renders_and_contains_children[chromium]"
    "test_folder_collapse_toggle[chromium]"
    "test_server_updates_text_value[chromium]"
    "test_text_input_change_callback[chromium]"
    "test_dropdown_selection_callback[chromium]"
    "test_server_value_update_round_trip[chromium]"

    # playwright._impl._errors.TimeoutError: Locator.wait_for: Timeout 5000ms exceeded.
    # (same issue with 20s)
    "test_long_underscore_label_wraps_within_container[chromium]"

    # AssertionError: Locator expected to have Value 'initial'
    "test_gui_state_sync_text[chromium]"

    # assert 0 != 0
    # (only when xdist)
    "test_server_port_is_freed"
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
