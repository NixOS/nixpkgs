{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
  gettext,
  pkg-config,
  wxGTK32,
  boost,
  icu,
  lucenepp,
  asciidoc,
  libxslt,
  xmlto,
  gtk3,
  gtkspell3,
  pugixml,
  nlohmann_json,
  hicolor-icon-theme,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "poedit";
  version = "3.4.4";

  src = fetchFromGitHub {
    owner = "vslavik";
    repo = "poedit";
    rev = "v${version}-oss";
    hash = "sha256-SZjsJQYJCXQendzQ2Tobg+IgkWL6lFX5YnMfruPt7UA=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    asciidoc
    wrapGAppsHook3
    libxslt
    xmlto
    boost
    libtool
    pkg-config
  ];

  buildInputs = [
    lucenepp
    nlohmann_json
    wxGTK32
    icu
    pugixml
    gtk3
    gtkspell3
    hicolor-icon-theme
  ];

  propagatedBuildInputs = [ gettext ];

  preConfigure = "
    patchShebangs bootstrap
    ./bootstrap
  ";

  configureFlags = [
    "--without-cld2"
    "--without-cpprest"
    "--with-boost-libdir=${boost.out}/lib"
    "CPPFLAGS=-I${nlohmann_json}/include/nlohmann/"
    "LDFLAGS=-llucene++"
  ];

  preFixup = ''
    gappsWrapperArgs+=(--prefix PATH : "${lib.makeBinPath [ gettext ]}")
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Cross-platform gettext catalogs (.po files) editor";
    mainProgram = "poedit";
    homepage = "https://www.poedit.net/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dasj19 ];
    # configure: error: GTK+ build of wxWidgets is required
    broken = stdenv.hostPlatform.isDarwin;
  };
}
