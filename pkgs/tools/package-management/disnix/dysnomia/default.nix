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
  name = "dysnomia-0.3pre7c81cc254a0f6966dd9ac55f945c458b45b3d428.tar.gz";
  src = fetchurl {
    url = http://hydra.nixos.org/build/5613342/download/1/dysnomia-0.3pre7c81cc254a0f6966dd9ac55f945c458b45b3d428.tar.gz;
    sha256 = "0ll09vh94ygqkncq4ddb62s4c84n3pr5qy0gi1ywy0j30qk6zvsq";
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
    description = "Automated deployment of mutable components and services for Disnix";
    license = "MIT";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
