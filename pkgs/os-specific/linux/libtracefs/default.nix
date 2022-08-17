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
  version = "1.4.2";

  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git";
    rev = "libtracefs-${version}";
    sha256 = "sha256-CmFzonPq91iLflolJaucpPWzb8MCgfuov/OQ6KUD3f4=";
  };

  postPatch = ''
    substituteInPlace scripts/utils.mk --replace /bin/pwd ${coreutils}/bin/pwd
    patchShebangs check-manpages.sh
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
