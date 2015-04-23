{ stdenv, fetchgit, asciidoc, docbook_xsl, libxslt }:

stdenv.mkDerivation rec {
  name    = "trace-cmd-${version}";
  version = "2.5.3";

  src = fetchgit {
    url    = "git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git";
    rev    = "refs/tags/trace-cmd-v${version}";
    sha256 = "32db3df07d0371c2b072029c6c86c4204be8cbbcb53840fa8c42dbf2e35c047b";
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
