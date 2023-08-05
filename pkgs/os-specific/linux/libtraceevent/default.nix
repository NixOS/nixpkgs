{ lib, stdenv, fetchgit, pkg-config, asciidoc, xmlto, docbook_xml_dtd_45, docbook_xsl, meson, ninja, cunit }:

stdenv.mkDerivation rec {
  pname = "libtraceevent";
  version = "1.7.3";

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git";
    rev = "libtraceevent-${version}";
    sha256 = "sha256-poF+Cqcdj0KIgEJWW7XDAlRLz2/Egi948s1M24ETvBo=";
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

  meta = with lib; {
    description = "Linux kernel trace event library";
    homepage    = "https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/";
    license     = licenses.lgpl21Only;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ wentasah ];
  };
}
