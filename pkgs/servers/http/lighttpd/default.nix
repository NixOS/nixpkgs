{ lib, stdenv, buildPackages, fetchurl, pkg-config, pcre2, libxml2, zlib, bzip2, which, file
, fetchpatch
, openssl
, enableDbi ? false, libdbi
, enableMagnet ? false, lua5_1
, enableMysql ? false, libmysqlclient
, enableLdap ? false, openldap
, enablePam ? false, linux-pam
, enableSasl ? false, cyrus_sasl
, enableWebDAV ? false, sqlite, libuuid
, enableExtendedAttrs ? false, attr
, perl
, nixosTests
}:

stdenv.mkDerivation rec {
  pname = "lighttpd";
  version = "1.4.73";

  src = fetchurl {
    url = "https://download.lighttpd.net/lighttpd/releases-${lib.versions.majorMinor version}.x/${pname}-${version}.tar.xz";
    sha256 = "sha256-gYgW0LMUsKqHKKcHZRNDX21esifzthMjRo4fENvoTKg=";
  };

  postPatch = ''
    patchShebangs tests
  '';

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ pcre2 pcre2.dev libxml2 zlib bzip2 which file openssl ]
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
    export PATH=$PATH:${pcre2.dev}/bin
    sed -i "s:/usr/bin/file:${file}/bin/file:g" configure
  '';

  nativeCheckInputs = [ perl ];
  doCheck = true;

  postInstall = ''
    mkdir -p "$out/share/lighttpd/doc/config"
    cp -vr doc/config "$out/share/lighttpd/doc/"
    # Remove files that references needless store paths (dependency bloat)
    rm "$out/share/lighttpd/doc/config/Makefile"*
    rm "$out/share/lighttpd/doc/config/conf.d/Makefile"*
    rm "$out/share/lighttpd/doc/config/vhosts.d/Makefile"*
  '';

  passthru.tests = {
    inherit (nixosTests) lighttpd;
  };

  meta = with lib; {
    description = "Lightweight high-performance web server";
    homepage = "http://www.lighttpd.net/";
    license = lib.licenses.bsd3;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ bjornfor brecht ];
    mainProgram = "lighttpd";
  };
}
