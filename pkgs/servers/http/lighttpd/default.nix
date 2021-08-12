{ lib, stdenv, buildPackages, fetchurl, pkg-config, pcre, libxml2, zlib, bzip2, which, file
, openssl
, enableDbi ? false, libdbi ? null
, enableMagnet ? false, lua5_1 ? null
, enableMysql ? false, libmysqlclient ? null
, enableLdap ? false, openldap ? null
, enablePam ? false, linux-pam ? null
, enableSasl ? false, cyrus_sasl ? null
, enableWebDAV ? false, sqlite ? null, libuuid ? null
, enableExtendedAttrs ? false, attr ? null
, perl
}:

assert enableDbi -> libdbi != null;
assert enableMagnet -> lua5_1 != null;
assert enableMysql -> libmysqlclient != null;
assert enableLdap -> openldap != null;
assert enablePam -> linux-pam != null;
assert enableSasl -> cyrus_sasl != null;
assert enableWebDAV -> sqlite != null;
assert enableWebDAV -> libuuid != null;
assert enableExtendedAttrs -> attr != null;

stdenv.mkDerivation rec {
  pname = "lighttpd";
  version = "1.4.59";

  src = fetchurl {
    url = "https://download.lighttpd.net/lighttpd/releases-${lib.versions.majorMinor version}.x/${pname}-${version}.tar.xz";
    sha256 = "sha256-+5U9snPa7wjttuICVWyuij0H7tYIHJa9mQPblX0QhNU=";
  };

  postPatch = ''
    patchShebangs tests
    # Linux sandbox has an empty hostname and not /etc/hosts, which fails some tests
    sed -ire '/[$]self->{HOSTNAME} *=/i     if(length($name)==0) { $name = "127.0.0.1" }' tests/LightyTest.pm
  '';

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pcre pcre.dev libxml2 zlib bzip2 which file openssl ]
             ++ lib.optional enableDbi libdbi
             ++ lib.optional enableMagnet lua5_1
             ++ lib.optional enableMysql libmysqlclient
             ++ lib.optional enableLdap openldap
             ++ lib.optional enablePam linux-pam
             ++ lib.optional enableSasl cyrus_sasl
             ++ lib.optional enableWebDAV sqlite
             ++ lib.optional enableWebDAV libuuid;

  configureFlags = [ "--with-openssl" ]
                ++ lib.optional enableDbi "--with-dbi"
                ++ lib.optional enableMagnet "--with-lua"
                ++ lib.optional enableMysql "--with-mysql"
                ++ lib.optional enableLdap "--with-ldap"
                ++ lib.optional enablePam "--with-pam"
                ++ lib.optional enableSasl "--with-sasl"
                ++ lib.optional enableWebDAV "--with-webdav-props"
                ++ lib.optional enableWebDAV "--with-webdav-locks"
                ++ lib.optional enableExtendedAttrs "--with-attr";

  preConfigure = ''
    export PATH=$PATH:${pcre.dev}/bin
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

  meta = with lib; {
    description = "Lightweight high-performance web server";
    homepage = "http://www.lighttpd.net/";
    license = lib.licenses.bsd3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ bjornfor brecht ];
  };
}
