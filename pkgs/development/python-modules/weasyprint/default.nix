{ lib
, stdenv
, buildPythonPackage
, cairosvg
, cffi
, cssselect2
, fetchPypi
, flit-core
, fontconfig
, fonttools
, ghostscript
, glib
, harfbuzz
, html5lib
, pango
, pillow
, pydyf
, pyphen
, pytestCheckHook
, pythonOlder
, substituteAll
, tinycss2
}:

buildPythonPackage rec {
  pname = "weasyprint";
  version = "57.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "weasyprint";
    hash = "sha256-e29cwTgZ6afYdIwdvw6NJET3pIGKmDOfgtzKqCK/kRs=";
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

  pythonImportsCheck = [
    "weasyprint"
  ];

  meta = with lib; {
    description = "Converts web documents to PDF";
    homepage = "https://weasyprint.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ elohmeier ];
  };
}
