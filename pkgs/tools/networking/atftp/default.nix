{ lib, stdenv, fetchurl, readline, tcp_wrappers, pcre, makeWrapper, gcc }:

stdenv.mkDerivation rec {
  name = "atftp-${version}";
  version = "0.7.2";

  src = fetchurl {
    url = "mirror://sourceforge/atftp/${name}.tar.gz";
    sha256 = "0hah3fhzl6vfs381883vbvf4d13cdhsyf0x7ncbl55wz9rkq1l0s";
  };

  buildInputs = [ readline tcp_wrappers pcre makeWrapper gcc ];

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
