{stdenv, fetchurl, enableServer ? false, postgresql ? null, curl ? null}:

stdenv.mkDerivation {
  name = "zabbix-1.4.5";

  src = fetchurl {
    url = mirror://sourceforge/zabbix/zabbix-1.4.5.tar.gz;
    sha256 = "1ha82q6rp49rgdfmni73y60kqjy00mfr2bp10mb0gnb0k4v9ppmb";
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
