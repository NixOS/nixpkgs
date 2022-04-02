{ lib, stdenv, fetchgit, pkg-config, asciidoc, xmlto, docbook_xml_dtd_45, docbook_xsl }:

stdenv.mkDerivation rec {
  pname = "libtraceevent";
  version = "1.5.1";

  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git";
    rev = "libtraceevent-${version}";
    sha256 = "sha256-g4dB8QhCG6SgZVAU3TCtb70vYYh1KN7FrcldzTGAUnI=";
  };

  # Don't build and install html documentation
  postPatch = ''
    sed -i -e '/^all:/ s/html//' -e '/^install:/ s/install-html//' Documentation/Makefile
  '';

  outputs = [ "out" "dev" "devman" ];
  enableParallelBuilding = true;
  nativeBuildInputs = [ pkg-config asciidoc xmlto docbook_xml_dtd_45 docbook_xsl ];
  makeFlags = [
    "prefix=${placeholder "out"}"
    "doc"                       # build docs
  ];
  installFlags = [
    "pkgconfig_dir=${placeholder "out"}/lib/pkgconfig"
    "doc-install"
  ];

  meta = with lib; {
    description = "Linux kernel trace event library";
    homepage    = "https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/";
    license     = licenses.lgpl21Only;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ wentasah ];
  };
}
