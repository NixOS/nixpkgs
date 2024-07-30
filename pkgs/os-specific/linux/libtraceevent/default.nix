{ lib, stdenv, fetchgit, pkg-config, asciidoc, xmlto, docbook_xml_dtd_45, docbook_xsl, meson, ninja, cunit, gitUpdater }:

stdenv.mkDerivation rec {
  pname = "libtraceevent";
  version = "1.8.2";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git";
    rev = "libtraceevent-${version}";
    hash = "sha256-2oa3pR8DOPaeHcoqcLX00ihx1lpXablnsf0IZR2sOm8=";
  };

  postPatch = ''
    chmod +x Documentation/install-docs.sh.in
    patchShebangs --build check-manpages.sh Documentation/install-docs.sh.in
  '';

  outputs = [ "out" "dev" "devman" "doc" ];
  nativeBuildInputs = [ meson ninja pkg-config asciidoc xmlto docbook_xml_dtd_45 docbook_xsl ];

  ninjaFlags = [ "all" "docs" ];

  doCheck = true;
  checkInputs = [ cunit ];

  passthru.updateScript = gitUpdater {
    # No nicer place to find latest release.
    url = "https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git";
    rev-prefix = "libtraceevent-";
  };

  meta = with lib; {
    description = "Linux kernel trace event library";
    homepage    = "https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/";
    license     = licenses.lgpl21Only;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ wentasah ];
  };
}
