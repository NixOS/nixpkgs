{
  lib,
  stdenv,
  buildPythonPackage,
  cffi,
  cssselect2,
  fetchPypi,
  flit-core,
  fontconfig,
  fonttools,
  ghostscript,
  glib,
  harfbuzz,
  pango,
  pillow,
  pydyf,
  pyphen,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  replaceVars,
  tinycss2,
  tinyhtml5,
}:

buildPythonPackage rec {
  pname = "weasyprint";
  version = "64.1";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit version;
    pname = "weasyprint";
    hash = "sha256-KLAvLGQJuvzhsSINnXanNFh1vTvQjE9t+/UQu5KpR1c=";
  };

  patches = [
    (replaceVars ./library-paths.patch {
      fontconfig = "${fontconfig.lib}/lib/libfontconfig${stdenv.hostPlatform.extensions.sharedLibrary}";
      pangoft2 = "${pango.out}/lib/libpangoft2-1.0${stdenv.hostPlatform.extensions.sharedLibrary}";
      gobject = "${glib.out}/lib/libgobject-2.0${stdenv.hostPlatform.extensions.sharedLibrary}";
      pango = "${pango.out}/lib/libpango-1.0${stdenv.hostPlatform.extensions.sharedLibrary}";
      harfbuzz = "${harfbuzz.out}/lib/libharfbuzz${stdenv.hostPlatform.extensions.sharedLibrary}";
      harfbuzz_subset = "${harfbuzz.out}/lib/libharfbuzz-subset${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  build-system = [ flit-core ];

  pythonRelaxDeps = [ "tinycss2" ];

  dependencies = [
    cffi
    cssselect2
    fonttools
    pillow
    pydyf
    pyphen
    tinycss2
    tinyhtml5
  ] ++ fonttools.optional-dependencies.woff;

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
    ghostscript
  ];

  disabledTests = [
    # needs the Ahem font (fails on macOS)
    "test_font_stretch"
    # sensitive to sandbox environments
    "test_tab_size"
    "test_tabulation_character"
    "test_linear_gradients_5"
    "test_linear_gradients_12"
    # rounding issues in sandbox
    "test_images_transparent_text"
    "test_visibility_1"
    "test_visibility_3"
    "test_visibility_4"
    "test_empty_inline_auto_margins"
    "test_vertical_align_4"
    "test_margin_boxes_element"
    "test_running_elements"
    "test_layout_table_auto_44"
    "test_layout_table_auto_45"
    "test_woff_simple"
  ];

  FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  # Set env variable explicitly for Darwin, but allow overriding when invoking directly
  makeWrapperArgs = [ "--set-default FONTCONFIG_FILE ${FONTCONFIG_FILE}" ];

  preCheck = ''
    # Fontconfig wants to create a cache.
    export HOME=$TMPDIR
  '';

  pythonImportsCheck = [ "weasyprint" ];

  meta = with lib; {
    changelog = "https://github.com/Kozea/WeasyPrint/releases/tag/v${version}";
    description = "Converts web documents to PDF";
    mainProgram = "weasyprint";
    homepage = "https://weasyprint.org/";
    license = licenses.bsd3;
  };
}
