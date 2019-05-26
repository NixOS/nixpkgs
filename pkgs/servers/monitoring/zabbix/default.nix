{ stdenv, fetchurl, pkgconfig, postgresql, curl, openssl, zlib }:

let

  version = "1.8.22";

  src = fetchurl {
    url = "mirror://sourceforge/zabbix/zabbix-${version}.tar.gz";
    sha256 = "0cjj3c4j4b9sl3hgh1fck330z9q0gz2k68g227y0paal6k6f54g7";
  };

  preConfigure =
    ''
      substituteInPlace ./configure \
        --replace " -static" "" \
        ${stdenv.lib.optionalString (stdenv.cc.libc != null) ''
          --replace /usr/include/iconv.h ${stdenv.lib.getDev stdenv.cc.libc}/include/iconv.h
        ''}
    '';

in

{

  server = stdenv.mkDerivation {
    name = "zabbix-${version}";

    inherit src preConfigure;

    configureFlags = [
      "--enable-agent"
      "--enable-server"
      "--with-pgsql"
      "--with-libcurl"
    ];

  nativeBuildInputs = [ pkgconfig ];
    buildInputs = [ postgresql curl openssl zlib ];

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
      homepage = https://www.zabbix.com/;
      license = "GPL";
      maintainers = [ stdenv.lib.maintainers.eelco ];
      platforms = stdenv.lib.platforms.linux;
    };
  };

  agent = stdenv.mkDerivation {
    name = "zabbix-agent-${version}";

    inherit src preConfigure;

    configureFlags = [ "--enable-agent" ];

    meta = with stdenv.lib; {
      description = "An enterprise-class open source distributed monitoring solution (client-side agent)";
      homepage = https://www.zabbix.com/;
      license = licenses.gpl2;
      maintainers = [ maintainers.eelco ];
      platforms = platforms.linux;
    };
  };

}
