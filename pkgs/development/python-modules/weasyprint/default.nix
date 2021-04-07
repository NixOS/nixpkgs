{ buildPythonPackage,
  fetchPypi,
  cairosvg,
  pyphen,
  cffi,
  cssselect,
  lxml,
  html5lib,
  tinycss,
  pygobject2,
  glib,
  pango,
  fontconfig,
  lib, stdenv,
  pytest,
  pytestrunner,
  pytest-isort,
  pytest-flake8,
  pytestcov,
  isPy3k,
  substituteAll
}:

buildPythonPackage rec {
  pname = "weasyprint";
  version = "52";
  disabled = !isPy3k;

  # excluded test needs the Ahem font
  checkPhase = ''
    runHook preCheck
    pytest -k 'not test_font_stretch'
    runHook postCheck
  '';

  # ignore failing flake8-test
  prePatch = ''
    substituteInPlace setup.cfg \
        --replace '[tool:pytest]' '[tool:pytest]\nflake8-ignore = E501'
  '';

  checkInputs = [ pytest pytestrunner pytest-isort pytest-flake8 pytestcov ];

  FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  propagatedBuildInputs = [ cairosvg pyphen cffi cssselect lxml html5lib tinycss pygobject2 ];

  patches = [
    (substituteAll {
      src = ./library-paths.patch;
      fontconfig = "${fontconfig.lib}/lib/libfontconfig${stdenv.hostPlatform.extensions.sharedLibrary}";
      pangoft2 = "${pango.out}/lib/libpangoft2-1.0${stdenv.hostPlatform.extensions.sharedLibrary}";
      gobject = "${glib.out}/lib/libgobject-2.0${stdenv.hostPlatform.extensions.sharedLibrary}";
      pango = "${pango.out}/lib/libpango-1.0${stdenv.hostPlatform.extensions.sharedLibrary}";
      pangocairo = "${pango.out}/lib/libpangocairo-1.0${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  src = fetchPypi {
    inherit version;
    pname = "WeasyPrint";
    sha256 = "0rwf43111ws74m8b1alkkxzz57g0np3vmd8as74adwnxslfcg4gs";
  };

  meta = with lib; {
    homepage = "https://weasyprint.org/";
    description = "Converts web documents to PDF";
    license = licenses.bsd3;
    maintainers = with maintainers; [ elohmeier ];
  };
}
