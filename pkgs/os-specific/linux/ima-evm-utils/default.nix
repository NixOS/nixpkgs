{ stdenv, fetchgit, autoreconfHook, pkgconfig, openssl, attr, keyutils, asciidoc, libxslt, docbook_xsl }:

stdenv.mkDerivation rec {
  pname = "ima-evm-utils";
  version = "1.1";

  src = fetchgit {
    url = "git://git.code.sf.net/p/linux-ima/ima-evm-utils";
    rev = "v${version}";
    sha256 = "1dhfw6d9z4dv82q9zg2g025hgr179kamz9chy7v5w9b71aam8jf8";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ openssl attr keyutils asciidoc libxslt ];

  patches = [ ./xattr.patch ];

  buildPhase = "make prefix=$out MANPAGE_DOCBOOK_XSL=${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl";

  meta = {
    description = "evmctl utility to manage digital signatures of the Linux kernel integrity subsystem (IMA/EVM)";
    homepage = "https://sourceforge.net/projects/linux-ima/";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
    maintainers = with stdenv.lib.maintainers; [ tstrobel ];
  };
}
