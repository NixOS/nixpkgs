<<<<<<< HEAD
{ lib, stdenv, fetchgit, pkg-config, asciidoc, xmlto, docbook_xml_dtd_45, docbook_xsl, meson, ninja, cunit }:

stdenv.mkDerivation rec {
  pname = "libtraceevent";
  version = "1.7.3";
=======
{ lib, stdenv, fetchgit, pkg-config, asciidoc, xmlto, docbook_xml_dtd_45, docbook_xsl, coreutils }:

stdenv.mkDerivation rec {
  pname = "libtraceevent";
  version = "1.6.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git";
    rev = "libtraceevent-${version}";
<<<<<<< HEAD
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
=======
    sha256 = "sha256-iLy2rEKn0UJguRcY/W8RvUq7uX+snQojb/cXOmMsjwc=";
  };

  # Don't build and install html documentation
  postPatch = ''
    sed -i -e '/^all:/ s/html//' -e '/^install:/ s/install-html//' Documentation/Makefile
    substituteInPlace scripts/utils.mk --replace /bin/pwd ${coreutils}/bin/pwd
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Linux kernel trace event library";
    homepage    = "https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/";
    license     = licenses.lgpl21Only;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ wentasah ];
  };
}
