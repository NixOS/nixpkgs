{ buildPythonPackage
, fetchPypi
, fetchpatch
, pytestCheckHook
, cairosvg
, flit-core
, fonttools
, pydyf
, pyphen
, cffi
, cssselect2
, html5lib
, tinycss2
, glib
, harfbuzz
, pango
, fontconfig
, lib
, stdenv
, ghostscript
, isPy3k
, substituteAll
, pillow
}:

buildPythonPackage rec {
  pname = "weasyprint";
  version = "54.3";
  disabled = !isPy3k;

  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "weasyprint";
    sha256 = "sha256-4E2gQGMFZsRMqiAgM/B/hYdl9TZwkEWoCXOfPQSOidY=";
  };

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
    # Disable tests for new Ghostscript
    # Remove when next version is released
    (fetchpatch {
      url = "https://github.com/Kozea/WeasyPrint/commit/e544398b00d76bc0317ea7e2abe40dc46b380910.patch";
      sha256 = "sha256-oQO3j9Mo1x98WaLPROxsOn0qkeYRJrCx5QWWKoHvabE=";
    })
  ];

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    cffi
    cssselect2
    fonttools
    html5lib
    pillow
    pydyf
    pyphen
    tinycss2
  ] ++ fonttools.optional-dependencies.woff;

  checkInputs = [
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
  ];

  FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--isort --flake8 --cov --no-cov-on-fail" ""
  '';

  preCheck = ''
    # Fontconfig wants to create a cache.
    export HOME=$TMPDIR
  '';

  meta = with lib; {
    homepage = "https://weasyprint.org/";
    description = "Converts web documents to PDF";
    license = licenses.bsd3;
    maintainers = with maintainers; [ elohmeier ];
  };
}
