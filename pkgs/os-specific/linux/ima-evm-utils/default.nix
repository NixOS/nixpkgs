{ stdenv, fetchgit, autoreconfHook, pkgconfig, openssl, attr, keyutils, asciidoc, libxslt, docbook_xsl }:

stdenv.mkDerivation rec {
  name = "ima-evm-utils-${version}";
  version = "1.0.0";

  src = fetchgit {
    url = "git://git.code.sf.net/p/linux-ima/ima-evm-utils";
    rev = "4b56112c095cb5cc34dc35abac37ebfc6eadba65";
    sha256 = "6f1ef4e84b9214448ea4a530a562a20ad1ba5a7cfefd7ddda90a56e2404f3a87";
  };

  buildInputs = [ autoreconfHook pkgconfig openssl attr keyutils asciidoc libxslt ];

  buildPhase = "make prefix=$out MANPAGE_DOCBOOK_XSL=${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl";

  meta = {
    description = "evmctl utility to manage digital signatures of the Linux kernel integrity subsystem (IMA/EVM)";
    homepage = "http://sourceforge.net/projects/linux-ima/";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
