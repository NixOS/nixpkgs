{ lib, stdenv, fetchurl, readline, tcp_wrappers, pcre, makeWrapper, gcc, ps }:

stdenv.mkDerivation rec {
  pname = "atftp";
  version = "0.7.5";

  src = fetchurl {
    url = "mirror://sourceforge/atftp/${pname}-${version}.tar.gz";
    sha256 = "12h3sgkd25j4nfagil2jqyj1n8yxvaawj0cf01742642n57pmj4k";
  };

  # fix test script
  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ readline tcp_wrappers pcre gcc ];

  # Expects pre-GCC5 inline semantics
  NIX_CFLAGS_COMPILE = "-std=gnu89";

  doCheck = true;
  checkInputs = [ ps ];

  meta = {
    description = "Advanced tftp tools";
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
}
