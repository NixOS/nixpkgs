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
  name = "disnix-activation-scripts-0.3predff2da00e2d29d15feb2b6b42931232d691f7f03";
  src = fetchurl {
    url = http://hydra.nixos.org/build/5430159/download/1/dysnomia-0.3predff2da00e2d29d15feb2b6b42931232d691f7f03.tar.gz;
    sha256 = "1y9qf14ygdgq2hjh1p6rf7hcgij02wv091s8wpsn36mrmc9zk6rf";
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

  meta = {
    description = "Provides various activation types for Disnix";
    license = "MIT";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
