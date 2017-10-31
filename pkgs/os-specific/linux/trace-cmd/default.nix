{ stdenv, fetchgit, asciidoc, docbook_xsl, libxslt }:

stdenv.mkDerivation rec {
  name    = "trace-cmd-${version}";
  version = "2.6";

  src = fetchgit {
    url    = "git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git";
    rev    = "refs/tags/trace-cmd-v${version}";
    sha256 = "15d6b7l766h2mamqgphx6l6a33b1zn0yar2h7i6b24ph6kz3idxn";
  };

  buildInputs = [ asciidoc libxslt ];

  configurePhase = "true";
  buildPhase     = "make prefix=$out MANPAGE_DOCBOOK_XSL=${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl all doc";
  installPhase   = "make prefix=$out install install_doc";

  meta = {
    description = "User-space tools for the Linux kernel ftrace subsystem";
    license     = stdenv.lib.licenses.gpl2;
    platforms   = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.thoughtpolice ];
  };
}
