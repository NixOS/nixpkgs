{
  lib,
  stdenv,
  python3,
  fetchFromGitHub,
  python3Packages,
  qtbase,
  wrapQtAppsHook,
  qtmultimedia,
  gst_all_1,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "vocabsieve";
  version = "0.11.0";
  format = "pyproject";
  src = fetchFromGitHub {
    owner = "FreeLanguageTools";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-7POxaMo37brZes1dz/bteGYN9MIkhVPiRIDMBPxw39A=";
  };

  nativeBuildInputs = [
    wrapQtAppsHook
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-vaapi
    gst_all_1.gstreamer
  ];

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
    makeWrapperArgs+=(--prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0")
  '';

  buildInputs = [qtbase qtmultimedia python3Packages.setuptools];

  propagatedBuildInputs = with python3Packages; [
    markdownify
    mobi
    pymorphy3
    pymorphy3-dicts-uk
    pymorphy3-dicts-ru
    simplemma
    requests
    readmdict
    slpp
    python-lzo
    packaging
    pyqtdarktheme
    sentence-splitter
    lxml
    pystardict
    flask
    pysubs2
    bidict
    markdown
    ebooklib
    flask-sqlalchemy
    pyqt5_with_qtmultimedia
    (pyqtgraph.override {pyqt5 = pyqt5_with_qtmultimedia;})
  ];

  meta = with lib; {
    description = "Simple sentence mining tool for language learning";
    homepage = "https://github.com/FreeLanguageTools/vocabsieve";
    license = licenses.gpl3;
    maintainers = [ maintainers.rasmusrendal ];
  };
}
