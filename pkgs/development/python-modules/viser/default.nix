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
  version = "1.0.27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "viser-project";
    repo = "viser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qE9V6KjniKm3vBtf5ger6UHob4go0wTaJnmYtvYqvMc=";
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

  # flaky tests
  disabledTests = [
    # AssertionError: Locator expected to be hidden
    "test_fuzzy_search_filters_commands[chromium]"
    "test_form_dirty_shows_on_sender[chromium]"

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
    "test_form_dirty_clears_on_submit_to_peer[chromium]"

    # playwright._impl._errors.TimeoutError: Locator.wait_for: Timeout 5000ms exceeded.
    "test_long_underscore_label_wraps_within_container[chromium]"
    "test_command_description_update[chromium]"
    "test_command_icon_update[chromium]"

    # playwright._impl._errors.TargetClosedError: Browser.new_context: Target page, context or browser has been closed
    "test_late_joining_client_sees_dirty_form[chromium]"
    "test_per_client_form_dirty_is_isolated[chromium]"
    "test_late_joining_client_sees_state[chromium]"
    "test_scene_node_drag_callbacks[chromium]"
    "test_scene_node_drag_filter_rejects_wrong_modifier[chromium]"
    "test_form_dirty_syncs_to_peer[chromium]"

    # AssertionError: Locator expected to have Value 'initial'
    "test_gui_state_sync_text[chromium]"

    # assert 0 != 0
    # (only when xdist)
    "test_server_port_is_freed"
  ];

  # 96 failed, 577 passed, 14 warnings on aarch64-linux
  doInstallCheck = stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isx86_64;

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
