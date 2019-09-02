{ stdenv, fetchurl, autoconf, automake, libtool, gettext, pkgconfig, wxGTK30,
  boost, icu, lucenepp, asciidoc, libxslt, xmlto, gtk2, gtkspell2, pugixml,
  nlohmann_json, hicolor-icon-theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "poedit";
  version = "2.2.1";

  src = fetchurl {
    url = "https://github.com/vslavik/poedit/archive/v${version}-oss.tar.gz";
    sha256 = "0brj6ysisxng2xn8l9ii2rngsj5b4rk27hzfjbp3zwb2caagd3vq";
  };

  nativeBuildInputs = [ autoconf automake asciidoc wrapGAppsHook 
    libxslt xmlto boost libtool pkgconfig ];

  buildInputs = [ lucenepp nlohmann_json wxGTK30 icu pugixml gtk2 gtkspell2 hicolor-icon-theme ];

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
    gappsWrapperArgs+=(--prefix PATH : "${stdenv.lib.makeBinPath [ gettext ]}")
  '';
 
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Cross-platform gettext catalogs (.po files) editor";
    homepage = https://www.poedit.net/;
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ domenkozar genesis ];
  };
}
