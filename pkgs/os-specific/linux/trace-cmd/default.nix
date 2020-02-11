{ stdenv, fetchgit, asciidoc, docbook_xsl, libxslt }:
stdenv.mkDerivation {
  pname = "trace-cmd";
  version = "2.9-dev";

  src = fetchgit (import ./src.nix);

  patches = [ ./fix-Makefiles.patch ];

  nativeBuildInputs = [ asciidoc libxslt ];

  outputs = [ "out" "lib" "dev" "man" ];

  MANPAGE_DOCBOOK_XSL="${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl";

  dontConfigure = true;

  buildPhase = "make trace-cmd libs doc";

  installTargets = [ "install_cmd" "install_libs" "install_doc" ];
  installFlags = [
    "bindir=${placeholder "out"}/bin"
    "man_dir=${placeholder "man"}/share/man"
    "libdir=${placeholder "lib"}/lib"
    "includedir=${placeholder "dev"}/include"
    "BASH_COMPLETE_DIR=${placeholder "out"}/etc/bash_completion.d"
  ];

  meta = with stdenv.lib; {
    description = "User-space tools for the Linux kernel ftrace subsystem";
    homepage    = https://kernelshark.org/;
    license     = licenses.gpl2;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ thoughtpolice basvandijk ];
  };
}
