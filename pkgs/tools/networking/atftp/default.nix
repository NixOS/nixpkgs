{ lib, stdenv, fetchurl, readline, tcp_wrappers, pcre, makeWrapper, gcc }:

stdenv.mkDerivation rec {
  name = "atftp-${version}";
  version = "0.7.1";

  src = fetchurl {
    url = "mirror://sourceforge/atftp/${name}.tar.gz";
    sha256 = "0bgr31gbnr3qx4ixf8hz47l58sh3367xhcnfqd8233fvr84nyk5f";
  };

  buildInputs = [ readline tcp_wrappers pcre makeWrapper gcc ];

  # Expects pre-GCC5 inline semantics
  NIX_CFLAGS_COMPILE = "-std=gnu89";

  meta = {
    description = "Advanced tftp tools";
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
  };
}
