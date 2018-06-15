{ stdenv, fetchurl, pkgconfig, pcre, libxml2, zlib, attr, bzip2, which, file
, openssl, enableMagnet ? false, lua5_1 ? null
, enableMysql ? false, mysql ? null
, enableLdap ? false, openldap ? null
, enableWebDAV ? true, sqlite ? null, libuuid ? null
}:

assert enableMagnet -> lua5_1 != null;
assert enableMysql -> mysql != null;
assert enableLdap -> openldap != null;
assert enableWebDAV -> sqlite != null;
assert enableWebDAV -> libuuid != null;

stdenv.mkDerivation rec {
  name = "lighttpd-1.4.49";

  src = fetchurl {
    url = "http://download.lighttpd.net/lighttpd/releases-1.4.x/${name}.tar.xz";
    sha256 = "02ff77cpvy1006cwfym38vf78xm18plyj636ll74r7kx2bblkpxf";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ pcre libxml2 zlib attr bzip2 which file openssl ]
             ++ stdenv.lib.optional enableMagnet lua5_1
             ++ stdenv.lib.optional enableMysql mysql.connector-c
             ++ stdenv.lib.optional enableLdap openldap
             ++ stdenv.lib.optional enableWebDAV sqlite
             ++ stdenv.lib.optional enableWebDAV libuuid;

  configureFlags = [ "--with-openssl" ]
                ++ stdenv.lib.optional enableMagnet "--with-lua"
                ++ stdenv.lib.optional enableMysql "--with-mysql"
                ++ stdenv.lib.optional enableLdap "--with-ldap"
                ++ stdenv.lib.optional enableWebDAV "--with-webdav-props"
                ++ stdenv.lib.optional enableWebDAV "--with-webdav-locks";

  preConfigure = ''
    sed -i "s:/usr/bin/file:${file}/bin/file:g" configure
  '';

  postInstall = ''
    mkdir -p "$out/share/lighttpd/doc/config"
    cp -vr doc/config "$out/share/lighttpd/doc/"
    # Remove files that references needless store paths (dependency bloat)
    rm "$out/share/lighttpd/doc/config/Makefile"*
    rm "$out/share/lighttpd/doc/config/conf.d/Makefile"*
    rm "$out/share/lighttpd/doc/config/vhosts.d/Makefile"*
  '';

  meta = with stdenv.lib; {
    description = "Lightweight high-performance web server";
    homepage = http://www.lighttpd.net/;
    license = stdenv.lib.licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
