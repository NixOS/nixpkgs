{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool, gettext, pkg-config, wxGTK32,
  boost, icu, lucenepp, asciidoc, libxslt, xmlto, gtk3, gtkspell3, pugixml,
  nlohmann_json, hicolor-icon-theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "poedit";
<<<<<<< HEAD
  version = "3.3.2";
=======
  version = "3.2.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "vslavik";
    repo = "poedit";
    rev = "v${version}-oss";
<<<<<<< HEAD
    hash = "sha256-4WImcTr2nWIdsYJ9ADztvjKEzHK4F8qpJ0QGMOfB3ng=";
=======
    sha256 = "sha256-kun1x1ql8KLS1+nh5+iItxYZnfvFcrx62cvX4OEczG4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ autoconf automake asciidoc wrapGAppsHook
    libxslt xmlto boost libtool pkg-config ];

  buildInputs = [ lucenepp nlohmann_json wxGTK32 icu pugixml gtk3 gtkspell3 hicolor-icon-theme ];

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
    homepage = "https://www.poedit.net/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dasj19 ];
    # configure: error: GTK+ build of wxWidgets is required
    broken = stdenv.isDarwin;
  };
}
