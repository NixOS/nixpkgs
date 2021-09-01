{ buildPythonPackage,
  fetchPypi,
  fetchpatch,
  cairosvg,
  pyphen,
  cffi,
  cssselect,
  lxml,
  html5lib,
  tinycss,
  glib,
  pango,
  fontconfig,
  lib, stdenv,
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

  checkInputs = [ pytest pytest-runner pytest-isort pytest-flake8 pytest-cov ];

  FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  propagatedBuildInputs = [ cairosvg pyphen cffi cssselect lxml html5lib tinycss ];

  # 47043a1fd7e50a892b9836466f521df85d597c4.patch can be removed after next release of weasyprint, see:
  # https://github.com/Kozea/WeasyPrint/issues/1333#issuecomment-818062970
  patches = [
    (fetchpatch {
      url = "https://github.com/Kozea/WeasyPrint/commit/47043a1fd7e50a892b9836466f521df85d597c44.patch";
      sha256 = "0l9z0hrav3bcdajlg3vbzljq0lkw7hlj8ppzrq3v21hbj1il1nsb";
    })
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
