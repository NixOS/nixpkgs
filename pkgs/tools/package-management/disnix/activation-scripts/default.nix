{ stdenv, fetchurl
, ejabberd ? null, mysql ? null, postgresql ? null, subversion ? null
, enableApacheWebApplication ? false
, enableAxis2WebService ? false
, enableEjabberdDump ? false
, enableMySQLDatabase ? false
, enablePostgreSQLDatabase ? false
, enableSubversionRepository ? false
, enableTomcatWebApplication ? false
, catalinaBaseDir ? "/var/tomcat"
}:

assert enableMySQLDatabase -> mysql != null;
assert enablePostgreSQLDatabase -> postgresql != null;
assert enableSubversionRepository -> subversion != null;
assert enableEjabberdDump -> ejabberd != null;

stdenv.mkDerivation {
  name = "disnix-activation-scripts-0.2pre25210";
  src = fetchurl {
    url = http://hydra.nixos.org/build/816489/download/1/disnix-activation-scripts-0.2pre25210.tar.gz;
    sha256 = "1jski4fjz4pmh0knh3rgfkkmc7i2krs164nh0fasbh2radksm0hl";
  };
  
  preConfigure = if enableEjabberdDump then "export PATH=$PATH:${ejabberd}/sbin" else "";
  
  configureFlags = ''
                     ${if enableApacheWebApplication then "--with-apache" else "--without-apache"}
		     ${if enableAxis2WebService then "--with-axis2" else "--without-axis2"}
		     ${if enableEjabberdDump then "--with-ejabberd" else "--without-ejabberd"}
		     ${if enableMySQLDatabase then "--with-mysql" else "--without-mysql"}
		     ${if enablePostgreSQLDatabase then "--with-postgresql" else "--without-postgresql"}
		     ${if enableSubversionRepository then "--with-subversion" else "--without-subversion"}
		     ${if enableTomcatWebApplication then "--with-tomcat=${catalinaBaseDir}" else "--without-tomcat"}
		   '';
		   
  buildInputs = []
                ++ stdenv.lib.optional enableEjabberdDump ejabberd
                ++ stdenv.lib.optional enableMySQLDatabase mysql
		++ stdenv.lib.optional enablePostgreSQLDatabase postgresql
		++ stdenv.lib.optional enableSubversionRepository subversion;
}
