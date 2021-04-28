{ lib, stdenv, fetchurl, readline, tcp_wrappers, pcre, makeWrapper, gcc }:

stdenv.mkDerivation rec {
  pname = "atftp";
  version = "0.7.4";

  src = fetchurl {
    url = "mirror://sourceforge/atftp/${pname}-${version}.tar.gz";
    sha256 = "sha256-08nNDZcd/Hhtel9AVcNdTmaq/IECrANHPvIlvfftsmo=";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ readline tcp_wrappers pcre gcc ];

  # Expects pre-GCC5 inline semantics
  NIX_CFLAGS_COMPILE = "-std=gnu89";

  doCheck = false; # fails

  meta = {
    description = "Advanced tftp tools";
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
}
