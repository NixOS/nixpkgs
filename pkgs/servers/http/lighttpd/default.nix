{ stdenv, fetchurl, pkgconfig, pcre, libxml2, zlib, attr, bzip2, which, file
, openssl, enableMagnet ? false, lua5 ? null
}:

assert enableMagnet -> lua5 != null;

stdenv.mkDerivation {
  name = "lighttpd-1.4.32";

  src = fetchurl {
    url = http://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-1.4.32.tar.xz;
    sha256 = "1hgd9bi4mrak732h57na89lqg58b1kkchnddij9gawffd40ghs0k";
  };

  buildInputs = [ pkgconfig pcre libxml2 zlib attr bzip2 which file openssl ]
             ++ stdenv.lib.optional enableMagnet lua5;

  configureFlags = [ "--with-openssl" ]
                ++ stdenv.lib.optional enableMagnet "--with-lua";

  preConfigure = ''
    sed -i "s:/usr/bin/file:${file}/bin/file:g" configure
  '';

  meta = with stdenv.lib; {
    description = "Lightweight high-performance web server";
    homepage = http://www.lighttpd.net/;
    license = "BSD";
    platforms = platforms.linux;
    maintainers = [maintainers.bjornfor];
  };
}
