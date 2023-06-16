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
, which
, valgrind
, sourceHighlight
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
    substituteInPlace scripts/utils.mk --replace /bin/pwd ${coreutils}/bin/pwd
    patchShebangs --build check-manpages.sh
  '';

  outputs = [ "out" "dev" "devman" "doc" ];
  enableParallelBuilding = true;
  nativeBuildInputs = [ pkg-config asciidoc xmlto docbook_xml_dtd_45 docbook_xsl which valgrind sourceHighlight ];
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
