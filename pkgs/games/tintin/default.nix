{ stdenv, fetchurl, lib, zlib, pcre
, tlsSupport ? true, gnutls ? null
# ^ set { tlsSupport = false; } to reduce closure size by ~= 18.6 MB
}:

assert tlsSupport -> gnutls != null;

stdenv.mkDerivation rec {
  name = "tintin-2.02.05";

  src = fetchurl {
    url    = "mirror://sourceforge/tintin/${name}.tar.gz";
    sha256 = "sha256-Y6cAUhItJNade8ASOVdF8aBBLf/UVqjoqrhXBNRL1aE=";
  };

  nativeBuildInputs = lib.optional tlsSupport gnutls.dev;
  buildInputs = [ zlib pcre ] ++ lib.optional tlsSupport gnutls;

  preConfigure = ''
    cd src
  '';

  meta = with lib; {
    description = "A free MUD client for macOS, Linux and Windows";
    homepage    = "http://tintin.sourceforge.net";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };
}
