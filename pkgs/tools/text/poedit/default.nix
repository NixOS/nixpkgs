{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool, gettext, pkg-config, wxGTK30-gtk3,
  boost, icu, lucenepp, asciidoc, libxslt, xmlto, gtk3, gtkspell3, pugixml,
  nlohmann_json, hicolor-icon-theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "poedit";
  version = "2.4.3";

  src = fetchFromGitHub {
    owner = "vslavik";
    repo = "poedit";
    rev = "v${version}-oss";
    sha256 = "02xf2w3d2lnr3vqmil9vvg9pir7d21x4zrj9xwpgb7dhs0gimj0x";
  };

  nativeBuildInputs = [ autoconf automake asciidoc wrapGAppsHook
    libxslt xmlto boost libtool pkg-config ];

  buildInputs = [ lucenepp nlohmann_json wxGTK30-gtk3 icu pugixml gtk3 gtkspell3 hicolor-icon-theme ];

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
  };
}
