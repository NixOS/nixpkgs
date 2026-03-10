{
  lib,
  stdenv,
  pkgs,
  buildPythonPackage,
  fetchFromGitHub,
  fontconfig,
  glib,
  harfbuzz,
  pango,

  # build-system
  flit-core,

  # dependencies
  cffi,
  cssselect2,
  fonttools,
  pillow,
  pydyf,
  pyphen,
  tinycss2,
  tinyhtml5,

  # tests
  pytest-cov-stub,
  pytestCheckHook,
  replaceVars,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "weasyprint";
  version = "68.0";
  pyproject = true;

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "Kozea";
    repo = "WeasyPrint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kAJgSQz1RKrPwzO7I5xHXyXcXYJtvca9izjrAgTy3ek=";
  };

  patches = [
    (replaceVars ./library-paths.patch {
      fontconfig = "${fontconfig.lib}/lib/libfontconfig${stdenv.hostPlatform.extensions.sharedLibrary}";
      gobject = "${glib.out}/lib/libgobject-2.0${stdenv.hostPlatform.extensions.sharedLibrary}";
      harfbuzz = "${harfbuzz.out}/lib/libharfbuzz${stdenv.hostPlatform.extensions.sharedLibrary}";
      harfbuzz_subset = "${harfbuzz.out}/lib/libharfbuzz-subset${stdenv.hostPlatform.extensions.sharedLibrary}";
      pango = "${pango.out}/lib/libpango-1.0${stdenv.hostPlatform.extensions.sharedLibrary}";
      pangoft2 = "${pango.out}/lib/libpangoft2-1.0${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  build-system = [ flit-core ];

  dependencies = [
    cffi
    cssselect2
    fonttools
    pillow
    pydyf
    pyphen
    tinycss2
    tinyhtml5
  ]
  ++ fonttools.optional-dependencies.woff;

  nativeCheckInputs = [
    pkgs.ghostscript
    pytest-cov-stub
    pytestCheckHook
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # needs the Ahem font (fails on macOS)
    "test_font_stretch"
    # sensitive to sandbox environments
    "test_linear_gradients_12"
    "test_linear_gradients_5"
    "test_tab_size"
    "test_tabulation_character"
    # rounding issues in sandbox
    "test_empty_inline_auto_margins"
    "test_images_transparent_text"
    "test_layout_table_auto_44"
    "test_layout_table_auto_45"
    "test_margin_boxes_element"
    "test_running_elements"
    "test_vertical_align_4"
    "test_visibility_1"
    "test_visibility_3"
    "test_visibility_4"
    "test_woff_simple"
    # AssertionError
    "test_2d_transform"
    # Reported upstream: https://github.com/Kozea/WeasyPrint/issues/2666
    "test_text_stroke"
  ];

  env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  # Set env variable explicitly for Darwin, but allow overriding when invoking directly
  makeWrapperArgs = [ "--set-default FONTCONFIG_FILE ${finalAttrs.env.FONTCONFIG_FILE}" ];

  pythonImportsCheck = [ "weasyprint" ];

  meta = {
    changelog = "https://github.com/Kozea/WeasyPrint/releases/tag/${finalAttrs.src.tag}";
    description = "Converts web documents to PDF";
    homepage = "https://weasyprint.org/";
    license = lib.licenses.bsd3;
    mainProgram = "weasyprint";
    maintainers = with lib.maintainers; [
      DutchGerman
      friedow
    ];
  };
})
