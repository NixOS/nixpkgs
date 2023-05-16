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
<<<<<<< HEAD
, valgrind
, sourceHighlight
, meson
, flex
, bison
, ninja
, cunit
=======
, which
, valgrind
, sourceHighlight
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "libtracefs";
<<<<<<< HEAD
  version = "1.7.0";
=======
  version = "1.6.4";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git";
    rev = "libtracefs-${version}";
<<<<<<< HEAD
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
=======
    sha256 = "sha256-fWop0EMkoVulLBzU7q8x1IhMtdnEJ89wMz0cz964F6s=";
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Linux kernel trace file system library";
    homepage    = "https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/";
    license     = licenses.lgpl21Only;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ wentasah ];
  };
}
