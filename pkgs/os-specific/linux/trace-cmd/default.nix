{ lib, stdenv, fetchpatch, fetchzip, pkg-config, asciidoc, xmlto, docbook_xsl, docbook_xml_dtd_45, libxslt, libtraceevent, libtracefs, zstd, sourceHighlight }:
stdenv.mkDerivation rec {
  pname = "trace-cmd";
  version = "3.2";

  src = fetchzip {
    url    = "https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/snapshot/trace-cmd-v${version}.tar.gz";
    hash   = "sha256-rTcaaEQ3Y4cneNnZSGiMZNp+Z7dyAa3oNTNMAEXr28g=";
  };

  patches = [
    # Upstream patches to be released in the next version
    (fetchpatch {
      sha256 = "sha256-eGuHODm29M7rbGYsyXUPoNe1xsIG3eJYhwXQDakRJHA=";
      url = "https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/patch/?id=6b07a7df871342068604b204711ab741d421d051";
    })
  ];

  # Don't build and install html documentation
  postPatch = ''
    sed -i -e '/^all:/ s/html//' -e '/^install:/ s/install-html//' \
       Documentation{,/trace-cmd,/libtracecmd}/Makefile
    patchShebangs check-manpages.sh
  '';

  nativeBuildInputs = [ asciidoc libxslt pkg-config xmlto docbook_xsl docbook_xml_dtd_45 sourceHighlight ];

  buildInputs = [ libtraceevent libtracefs zstd ];

  outputs = [ "out" "lib" "dev" "man" "devman" ];

  MANPAGE_DOCBOOK_XSL="${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl";

  dontConfigure = true;

  enableParallelBuilding = true;
  makeFlags = [
    # The following values appear in the generated .pc file
    "prefix=${placeholder "lib"}"
  ];

  # We do not mention targets (like "doc") explicitly in makeFlags
  # because the Makefile would not print warnings about too old
  # libraries (see "warning:" in the Makefile)
  postBuild = ''
    make libs doc -j$NIX_BUILD_CORES
  '';

  installTargets = [
    "install_cmd"
    "install_libs"
    "install_doc"
  ];
  installFlags = [
    "LDCONFIG=false"
    "bindir=${placeholder "out"}/bin"
    "mandir=${placeholder "man"}/share/man"
    "libdir=${placeholder "lib"}/lib"
    "pkgconfig_dir=${placeholder "dev"}/lib/pkgconfig"
    "includedir=${placeholder "dev"}/include"
    "BASH_COMPLETE_DIR=${placeholder "out"}/share/bash-completion/completions"
  ];

  meta = with lib; {
    description = "User-space tools for the Linux kernel ftrace subsystem";
    homepage    = "https://www.trace-cmd.org/";
    license     = with licenses; [ lgpl21Only gpl2Only ];
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice basvandijk wentasah ];
  };
}
