{ stdenv, fetchurl, pkgconfig, pcre, libxml2, zlib, bzip2, which, file
, openssl, enableMagnet ? false, lua5_1 ? null
, enableMysql ? false, mysql ? null
, enableLdap ? false, openldap ? null
, enableWebDAV ? false, sqlite ? null, libuuid ? null
, enableExtendedAttrs ? false, attr ? null
, perl
}:

assert enableMagnet -> lua5_1 != null;
assert enableMysql -> mysql != null;
assert enableLdap -> openldap != null;
assert enableWebDAV -> sqlite != null;
assert enableWebDAV -> libuuid != null;
assert enableExtendedAttrs -> attr != null;

stdenv.mkDerivation rec {
  name = "lighttpd-1.4.52";

  src = fetchurl {
    url = "https://download.lighttpd.net/lighttpd/releases-1.4.x/${name}.tar.xz";
    sha256 = "0r57zp7050qxlwg41xqnqnhw3lrl34cg5zvfbqrwddrhqn8hkg17";
  };

  postPatch = ''
    patchShebangs tests
    # Linux sandbox has an empty hostname and not /etc/hosts, which fails some tests
    sed -ire '/[$]self->{HOSTNAME} *=/i     if(length($name)==0) { $name = "127.0.0.1" }' tests/LightyTest.pm
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ pcre libxml2 zlib bzip2 which file openssl ]
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
                ++ stdenv.lib.optional enableWebDAV "--with-webdav-locks"
                ++ stdenv.lib.optional enableExtendedAttrs "--with-attr";

  preConfigure = ''
    sed -i "s:/usr/bin/file:${file}/bin/file:g" configure
  '';

  checkInputs = [ perl ];
  doCheck = true;

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
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = [ maintainers.bjornfor ];
  };
}
