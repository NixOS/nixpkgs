{ lib
, stdenv
, fetchgit
, pkg-config
, libtraceevent
, asciidoc
, xmlto
, docbook_xml_dtd_45
, docbook_xsl
, coreutils
, valgrind
, sourceHighlight
, meson
, flex
, bison
, ninja
, cunit
}:

stdenv.mkDerivation rec {
  pname = "libtracefs";
  version = "1.7.0";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git";
    rev = "libtracefs-${version}";
    sha256 = "sha256-64eXFFdnZHHf4C3vbADtPuIMsfJ85VZ6t8A1gIc1CW0=";
  };

  postPatch = ''
    chmod +x samples/extract-example.sh
    patchShebangs --build check-manpages.sh samples/extract-example.sh Documentation/install-docs.sh.in
  '';

  outputs = [ "out" "dev" "devman" "doc" ];
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    asciidoc
    xmlto
    docbook_xml_dtd_45
    docbook_xsl
    valgrind
    sourceHighlight
    flex
    bison
  ];
  buildInputs = [ libtraceevent ];

  ninjaFlags = [ "all" "docs" ];

  doCheck = true;
  checkInputs = [ cunit ];

  meta = with lib; {
    description = "Linux kernel trace file system library";
    homepage    = "https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/";
    license     = licenses.lgpl21Only;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ wentasah ];
  };
}
