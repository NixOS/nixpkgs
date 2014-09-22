{ stdenv, fetchurl, gmp, autoreconfHook, gettext, pkgconfig }:

stdenv.mkDerivation rec {
  name = "strongswan-5.2.0";

  src = fetchurl {
    url = "http://download.strongswan.org/${name}.tar.bz2";
    sha256 = "1ki6v9c54ykppqnj3prgh62na97yajnvnm2zr1gjxzv05syk035h";
  };

  patches = [ ./respect-path.patch ./no-sysconfdir-write.patch ];

  buildInputs = [ gmp autoreconfHook gettext pkgconfig ];

  configureFlags = [ "--enable-swanctl" "--sysconfdir=/etc" ];

  meta = {
    maintainers = [ stdenv.lib.maintainers.shlevy ];
    description = "OpenSource IPsec-based VPN Solution";
    homepage = https://www.strongswan.org;
    license = stdenv.lib.licenses.gpl2Plus;
    inherit (stdenv.gcc.clang.meta) platforms;
  };
}
