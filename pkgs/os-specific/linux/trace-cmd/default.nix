{ lib, stdenv, fetchgit, pkg-config, asciidoc, xmlto, docbook_xsl, docbook_xml_dtd_45, libxslt, libtraceevent, libtracefs, zstd, sourceHighlight }:
stdenv.mkDerivation rec {
  pname = "trace-cmd";
<<<<<<< HEAD
  version = "3.2";
=======
  version = "3.1.6";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchgit {
    url    = "https://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/";
    rev    = "trace-cmd-v${version}";
<<<<<<< HEAD
    sha256 = "sha256-KlykIYF4uy1phgWRG5j76FJqgO7XhNnyrTDVTs8YOXY=";
=======
    sha256 = "sha256-qjfeomeExjsx/6XrUaGm5szbL7XVlekGd4Hsuncv8NY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # Don't build and install html documentation
  postPatch = ''
    sed -i -e '/^all:/ s/html//' -e '/^install:/ s/install-html//' \
       Documentation{,/trace-cmd,/libtracecmd}/Makefile
    patchShebangs check-manpages.sh
  '';

  nativeBuildInputs = [ asciidoc libxslt pkg-config xmlto docbook_xsl docbook_xml_dtd_45 sourceHighlight ];

  buildInputs = [ libtraceevent libtracefs zstd ];

<<<<<<< HEAD
  outputs = [ "out" "lib" "dev" "man" "devman" ];
=======
  outputs = [ "out" "lib" "dev" "man" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    maintainers = with maintainers; [ thoughtpolice basvandijk wentasah ];
=======
    maintainers = with maintainers; [ thoughtpolice basvandijk ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
