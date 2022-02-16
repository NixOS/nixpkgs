{ buildPythonPackage
, fetchPypi
, pytestCheckHook
, brotli
, flit-core
, fonttools
, pydyf
, pyphen
, cffi
, cssselect2
, pillow
, html5lib
, tinycss2
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
  version = "54.1";
  disabled = !isPy3k;

  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "weasyprint";
    sha256 = "sha256-+lfbhi4GvQHF59gtrTmbO5lSo5gnAjwXvumxwGH/G70=";
  };

  patches = [
    (substituteAll {
      src = ./library-paths.patch;
      fontconfig = "${fontconfig.lib}/lib/libfontconfig${stdenv.hostPlatform.extensions.sharedLibrary}";
      pangoft2 = "${pango.out}/lib/libpangoft2-1.0${stdenv.hostPlatform.extensions.sharedLibrary}";
      gobject = "${glib.out}/lib/libgobject-2.0${stdenv.hostPlatform.extensions.sharedLibrary}";
      pango = "${pango.out}/lib/libpango-1.0${stdenv.hostPlatform.extensions.sharedLibrary}";
      harfbuzz = "${harfbuzz.out}/lib/libharfbuzz${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    brotli
    cffi
    cssselect2
    pillow
    fonttools
    html5lib
    flit-core
    pydyf
    pyphen
    tinycss2
    zopfli
  ];

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
    "test_http"
  ];

  FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  makeWrapperArgs = [ "--set FONTCONFIG_FILE ${fontconfig.out}/etc/fonts/fonts.conf" ];

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
