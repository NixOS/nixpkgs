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
  stdenv,
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
  version = "47";
  disabled = !isPy3k;

  # ignore failing pytest
  checkPhase = "pytest -k 'not test_font_stretch'";

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
    sha256 = "0hd1zwrkfnj7g0jaaf6jvarlj6l5imar6ar78zxdgv17a3s3k3dg";
  };

  meta = with stdenv.lib; {
    homepage = https://weasyprint.org/;
    description = "Converts web documents to PDF";
    license = licenses.bsd3;
    maintainers = with maintainers; [ elohmeier ];
  };
}
