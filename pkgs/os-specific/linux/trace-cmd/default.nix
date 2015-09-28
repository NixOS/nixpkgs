{ stdenv, fetchgit, asciidoc, docbook_xsl, libxslt }:

stdenv.mkDerivation rec {
  name    = "trace-cmd-${version}";
  version = "2.6";

  src = fetchgit {
    url    = "git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git";
    rev    = "refs/tags/trace-cmd-v${version}";
    sha256 = "42286440a45d1b24552a1d3cdb656dc648ad346fc426b5798bacdbffd3c4b226";
  };

  buildInputs = [ asciidoc libxslt ];

  configurePhase = "true";
  buildPhase     = "make prefix=$out MANPAGE_DOCBOOK_XSL=${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl all doc";
  installPhase   = "make prefix=$out install install_doc";

  meta = {
    description = "user-space tools for the Linux kernel ftrace subsystem";
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
