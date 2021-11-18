{ buildPythonPackage,
  fetchPypi,
  fetchpatch,
  pytestCheckHook,
  brotli,
  cairosvg,
  fonttools,
  pydyf,
  pyphen,
  cffi,
  cssselect,
  lxml,
  html5lib,
  tinycss,
  zopfli,
  glib,
  harfbuzz,
  pango,
  fontconfig,
  lib, stdenv,
  ghostscript,
  pytest,
  pytest-runner,
  pytest-isort,
  pytest-flake8,
  pytest-cov,
  isPy3k,
  substituteAll
}:

buildPythonPackage rec {
  pname = "weasyprint";
  version = "53.4";
  disabled = !isPy3k;

  pytestFlagsArray = [
    # setup.py is auto-generated and doesn't pass the flake8 check
    "--ignore=setup.py"
    # ffi.py is patched by us and doesn't pass the flake8 check
    "--ignore=weasyprint/text/ffi.py"
  ];

  disabledTests = [
    # test_font_stretch needs the Ahem font (fails on macOS)
    "test_font_stretch"
  ];

  checkInputs = [
    pytestCheckHook
    ghostscript
    pytest
    pytest-runner
    pytest-isort
    pytest-flake8
    pytest-cov
  ];

  FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  propagatedBuildInputs = [
    brotli
    cairosvg
    cffi
    cssselect
    fonttools
    html5lib
    lxml
    pydyf
    pyphen
    tinycss
    zopfli
  ];

  patches = [
    (substituteAll {
      src = ./library-paths.patch;
      fontconfig = "${fontconfig.lib}/lib/libfontconfig${stdenv.hostPlatform.extensions.sharedLibrary}";
      pangoft2 = "${pango.out}/lib/libpangoft2-1.0${stdenv.hostPlatform.extensions.sharedLibrary}";
      gobject = "${glib.out}/lib/libgobject-2.0${stdenv.hostPlatform.extensions.sharedLibrary}";
      pango = "${pango.out}/lib/libpango-1.0${stdenv.hostPlatform.extensions.sharedLibrary}";
      pangocairo = "${pango.out}/lib/libpangocairo-1.0${stdenv.hostPlatform.extensions.sharedLibrary}";
      harfbuzz = "${harfbuzz.out}/lib/libharfbuzz${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  src = fetchPypi {
    inherit version;
    pname = "weasyprint";
    sha256 = "sha256-EMyxfVXHMJa98e3T7+WMuFWwfkwwfZutTryaPxP/RYA=";
  };

  meta = with lib; {
    homepage = "https://weasyprint.org/";
    description = "Converts web documents to PDF";
    license = licenses.bsd3;
    maintainers = with maintainers; [ elohmeier ];
  };
}
