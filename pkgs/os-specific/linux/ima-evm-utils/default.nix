{ lib, stdenv, fetchgit, autoreconfHook, pkg-config, openssl, attr, keyutils, asciidoc, libxslt, docbook_xsl }:

stdenv.mkDerivation rec {
  pname = "ima-evm-utils";
  version = "1.4";

  src = fetchgit {
    url = "git://git.code.sf.net/p/linux-ima/ima-evm-utils";
    rev = "v${version}";
    sha256 = "1zmyv82232lzqk52m0s7fap9zb9hb1x6nsi5gznk0cbsnq2m67pc";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ openssl attr keyutils asciidoc libxslt ];

  MANPAGE_DOCBOOK_XSL = "${docbook_xsl}/xml/xsl/docbook/manpages/docbook.xsl";

  meta = {
    description = "evmctl utility to manage digital signatures of the Linux kernel integrity subsystem (IMA/EVM)";
    homepage = "https://sourceforge.net/projects/linux-ima/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
  };
}
