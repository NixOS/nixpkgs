{ buildPythonPackage
, fetchPypi
, fetchpatch
, pytestCheckHook
, brotli
, cairosvg
, flit-core
, fonttools
, pydyf
, pyphen
, cffi
, cssselect
, lxml
, html5lib
, tinycss
, zopfli
, glib
, harfbuzz
, pango
, fontconfig
, lib
, stdenv
, ghostscript
, isPy3k
, substituteAll
}:

buildPythonPackage rec {
  pname = "weasyprint";
  version = "54.0";
  disabled = !isPy3k;

  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "weasyprint";
    sha256 = "0aeda9a045c7881289420cac917cc57115b1243e476187338e66d593dd000853";
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
  ];

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    brotli
    cairosvg
    cffi
    cssselect
    fonttools
    html5lib
    lxml
    flit-core
    pydyf
    pyphen
    tinycss
    zopfli
  ];

  checkInputs = [
    pytestCheckHook
    ghostscript
  ];

  disabledTests = [
    # needs the Ahem font (fails on macOS)
    "test_font_stretch"
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
