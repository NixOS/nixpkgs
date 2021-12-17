{ lib, stdenv, fetchgit, pkg-config, libtraceevent, asciidoc, xmlto, docbook_xml_dtd_45, docbook_xsl }:

stdenv.mkDerivation rec {
  pname = "libtracefs";
  version = "1.2.5";

  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git";
    rev = "libtracefs-${version}";
    sha256 = "1rva9ysspf1wqd0zf52qwgpaasrn7jcbns4dwldc59ksk0n93qdb";
  };

  # Don't build and install html documentation
  postPatch = ''
    sed -i -e '/^all:/ s/html//' -e '/^install:/ s/install-html//' Documentation/Makefile
  '';

  outputs = [ "out" "dev" "devman" ];
  enableParallelBuilding = true;
  nativeBuildInputs = [ pkg-config asciidoc xmlto docbook_xml_dtd_45 docbook_xsl ];
  buildInputs = [ libtraceevent ];
  makeFlags = [
    "prefix=${placeholder "out"}"
    "doc"                       # build docs
  ];
  installFlags = [
    "pkgconfig_dir=${placeholder "out"}/lib/pkgconfig"
    "install_doc"
  ];

  meta = with lib; {
    description = "Linux kernel trace file system library";
    homepage    = "https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/";
    license     = licenses.lgpl21Only;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ wentasah ];
  };
}
