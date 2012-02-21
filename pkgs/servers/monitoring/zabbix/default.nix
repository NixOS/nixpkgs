{ stdenv, fetchurl, pkgconfig, postgresql, curl, openssl, zlib }:

let

  version = "1.8.10";
  
  src = fetchurl {
    url = "mirror://sourceforge/zabbix/zabbix-${version}.tar.gz";
    sha256 = "0jx5i1ps1zr908g8gh1zisajiblg40x8cchmgbpdviz85hzx4rfr";
  };

  preConfigure =
    ''
      substituteInPlace ./configure \
        --replace " -static" "" \
        ${stdenv.lib.optionalString (stdenv.gcc.libc != null) ''
          --replace /usr/include/iconv.h ${stdenv.gcc.libc}/include/iconv.h
        ''}
    '';

in

{

  server = stdenv.mkDerivation {
    name = "zabbix-${version}";

    inherit src preConfigure;

    configureFlags = "--enable-agent --enable-server --with-pgsql --with-libcurl";

    buildInputs = [ pkgconfig postgresql curl openssl zlib ];

    postInstall =
      ''
        mkdir -p $out/share/zabbix
        cp -prvd frontends/php $out/share/zabbix/php
        mkdir -p $out/share/zabbix/db/data
        cp -prvd create/data/*.sql $out/share/zabbix/db/data
        mkdir -p $out/share/zabbix/db/schema
        cp -prvd create/schema/*.sql $out/share/zabbix/db/schema
      '';

    meta = {
      description = "An enterprise-class open source distributed monitoring solution";
      homepage = http://www.zabbix.com/;
      license = "GPL";
      maintainers = [ stdenv.lib.maintainers.eelco ];
      platforms = stdenv.lib.platforms.linux;
    };
  };
  
  agent = stdenv.mkDerivation {
    name = "zabbix-agent-${version}";

    inherit src preConfigure;

    configureFlags = "--enable-agent";

    meta = {
      description = "An enterprise-class open source distributed monitoring solution (client-side agent)";
      homepage = http://www.zabbix.com/;
      license = "GPL";
      maintainers = [ stdenv.lib.maintainers.eelco ];
      platforms = stdenv.lib.platforms.all;
    };
  };
  
}
