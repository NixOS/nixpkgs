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
<<<<<<< HEAD
  version = "59.0";
=======
  version = "58.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "weasyprint";
<<<<<<< HEAD
    hash = "sha256-Ijp2Y2s3ROqkq4oohfUM9Gz467GsuZtSdtAv7M9QdJI=";
=======
    hash = "sha256-YXMAnjE75lgH/vv3ioBRzrepN3bv2n67uIwT9XaXlPM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

  nativeCheckInputs = [
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

<<<<<<< HEAD
  # Set env variable explicitly for Darwin, but allow overriding when invoking directly
  makeWrapperArgs = [
    "--set-default FONTCONFIG_FILE ${FONTCONFIG_FILE}"
=======
  # Fontconfig error: Cannot load default config file: No such file: (null)
  makeWrapperArgs = [
    "--set FONTCONFIG_FILE ${FONTCONFIG_FILE}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

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
