{ stdenv, fetchurl, pkgconfig, pcre, libxml2, zlib, attr, bzip2, which, file
, openssl, enableMagnet ? false, lua5_1 ? null
, enableMysql ? false, mysql ? null
}:

assert enableMagnet -> lua5_1 != null;
assert enableMysql -> mysql != null;

stdenv.mkDerivation rec {
  name = "lighttpd-1.4.35";

  src = fetchurl {
    url = "http://download.lighttpd.net/lighttpd/releases-1.4.x/${name}.tar.xz";
    sha256 = "18rh7xyx69xbwl20znnjma1dq5fay0ygjjvpn3gaa7dxrir9nghi";
  };

  buildInputs = [ pkgconfig pcre libxml2 zlib attr bzip2 which file openssl ]
             ++ stdenv.lib.optional enableMagnet lua5_1
             ++ stdenv.lib.optional enableMysql mysql.lib;

  configureFlags = [ "--with-openssl" ]
                ++ stdenv.lib.optional enableMagnet "--with-lua"
                ++ stdenv.lib.optional enableMysql "--with-mysql";

  preConfigure = ''
    sed -i "s:/usr/bin/file:${file}/bin/file:g" configure
  '';

  meta = with stdenv.lib; {
    description = "Lightweight high-performance web server";
    homepage = http://www.lighttpd.net/;
    license = stdenv.lib.licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
