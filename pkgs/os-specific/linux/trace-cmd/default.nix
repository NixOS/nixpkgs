{ lib, stdenv, fetchgit, pkg-config, asciidoc, xmlto, docbook_xsl, libxslt, libtraceevent, libtracefs }:
stdenv.mkDerivation rec {
  pname = "trace-cmd";
  version = "2.9.7";

  src = fetchgit {
    url    = "git://git.kernel.org/pub/scm/utils/trace-cmd/trace-cmd.git/";
    rev    = "trace-cmd-v${version}";
    sha256 = "sha256-04qsTlOVYh/jHVWxaGuqYj4DkUpcEYcpfUqnqhphIMg=";
  };

  # Don't build and install html documentation
  postPatch = ''
    sed -i -e '/^all:/ s/html//' -e '/^install:/ s/install-html//' \
       Documentation{,/trace-cmd,/libtracecmd}/Makefile
  '';

  nativeBuildInputs = [ asciidoc libxslt pkg-config xmlto ];

  buildInputs = [ libtraceevent libtracefs ];

  outputs = [ "out" "lib" "dev" "man" ];

  MANPAGE_DOCBOOK_XSL="${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl";

  dontConfigure = true;

  enableParallelBuilding = true;
  makeFlags = [
    "all" "libs" "doc"
    # The following values appear in the generated .pc file
    "prefix=${placeholder "lib"}"
    "libdir=${placeholder "lib"}/lib"
    "includedir=${placeholder "dev"}/include"
  ];

  installTargets = [ "install_cmd" "install_libs" "install_doc" ];
  installFlags = [
    "bindir=${placeholder "out"}/bin"
    "man_dir=${placeholder "man"}/share/man"
    "libdir=${placeholder "lib"}/lib"
    "pkgconfig_dir=${placeholder "lib"}/lib/pkgconfig"
    "includedir=${placeholder "dev"}/include"
    "BASH_COMPLETE_DIR=${placeholder "out"}/share/bash-completion/completions"
  ];

  meta = with lib; {
    description = "User-space tools for the Linux kernel ftrace subsystem";
    homepage    = "https://www.trace-cmd.org/";
    license     = with licenses; [ lgpl21Only gpl2Only ];
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice basvandijk ];
  };
}
