{
  lib,
  stdenv,
  pkgs,
  buildPythonPackage,
  fetchFromGitHub,
  fontconfig,
  glib,
  harfbuzz,
  makeFontsConf,
  pango,
  twemoji-color-font,

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
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

let
  libPath = pkg: name: "${lib.getLib pkg}/lib/${name}${stdenv.hostPlatform.extensions.sharedLibrary}";
in
buildPythonPackage (finalAttrs: {
  pname = "weasyprint";
  version = "70.0";
  pyproject = true;

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "Kozea";
    repo = "WeasyPrint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tb/E27Vmt3xh0MyWv25WVm1eIDo+OtNFKhap8alZaUo=";
  };

  # Upstream tries several library names per platform; point the first one at
  # the store path and only try that one, so no host libraries are ever picked up.
  # libharfbuzz-vector is optional (COLR emoji fonts) and only present when
  # harfbuzz is built with `withVector = true`.
  postPatch = ''
    substituteInPlace weasyprint/text/ffi.py \
      --replace-fail "for name in names:" "for name in names[:1]:" \
      --replace-fail "'libgobject-2.0-0'" "'${libPath glib "libgobject-2.0"}'" \
      --replace-fail "'libpango-1.0-0'" "'${libPath pango "libpango-1.0"}'" \
      --replace-fail "'libpangoft2-1.0-0'" "'${libPath pango "libpangoft2-1.0"}'" \
      --replace-fail "'libharfbuzz-0'" "'${libPath harfbuzz "libharfbuzz"}'" \
      --replace-fail "'libharfbuzz-subset-0'" "'${libPath harfbuzz "libharfbuzz-subset"}'" \
      --replace-fail "'libharfbuzz-vector-0'" "'${libPath harfbuzz "libharfbuzz-vector"}'" \
      --replace-fail "'libfontconfig-1'" "'${libPath fontconfig "libfontconfig"}'"
  '';

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
  ];

  env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  # Custom font configuration for tests
  preCheck = ''
    export FONTCONFIG_FILE=${
      makeFontsConf {
        # include some emoji characters
        fontDirectories = [ twemoji-color-font ];

        # Darwin builds without sandbox can pollute the build
        impureFontDirectories = [ ];
      }
    }
  '';

  # Set env variable explicitly for Darwin, but allow overriding when invoking directly
  makeWrapperArgs = [
    "--set-default"
    "FONTCONFIG_FILE"
    finalAttrs.env.FONTCONFIG_FILE
  ];

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
