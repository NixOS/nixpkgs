{stdenv, fetchurl, enableServer ? false, postgresql ? null, curl ? null}:

stdenv.mkDerivation {
  name = "zabbix-1.4.6";

  src = fetchurl {
    url = mirror://sourceforge/zabbix/zabbix-1.4.6.tar.gz;
    sha256 = "19xczaiprn820jnq9lhixdhd3d6ffkjk80l98lwxzrz2zc2s06n9";
  };

  configureFlags = "--enable-agent " +
    (if enableServer then ''
      --enable-server
      --with-pgsql
      --with-libcurl
    '' else "");

  buildInputs = stdenv.lib.optionals enableServer [postgresql curl];

  postInstall = if enableServer then ''
    ensureDir $out/share/zabbix
    cp -prvd frontends/php $out/share/zabbix/php
    ensureDir $out/share/zabbix/db/data
    cp -prvd create/data/*.sql $out/share/zabbix/db/data
    ensureDir $out/share/zabbix/db/schema
    cp -prvd create/schema/*.sql $out/share/zabbix/db/schema
  '' else ""; # */

  meta = {
    description = "An enterprise-class open source distributed monitoring solution";
    homepage = http://www.zabbix.com/;
    license = "GPL";
  };
}
