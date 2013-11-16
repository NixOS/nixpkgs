{ stdenv, fetchurl
, ejabberd ? null, mysql ? null, postgresql ? null, subversion ? null, mongodb ? null
, enableApacheWebApplication ? false
, enableAxis2WebService ? false
, enableEjabberdDump ? false
, enableMySQLDatabase ? false
, enablePostgreSQLDatabase ? false
, enableSubversionRepository ? false
, enableTomcatWebApplication ? false
, enableMongoDatabase ? false
, catalinaBaseDir ? "/var/tomcat"
}:

assert enableMySQLDatabase -> mysql != null;
assert enablePostgreSQLDatabase -> postgresql != null;
assert enableSubversionRepository -> subversion != null;
assert enableEjabberdDump -> ejabberd != null;
assert enableMongoDatabase -> mongodb != null;

stdenv.mkDerivation {
  name = "dysnomia-0.3pred677260f77bb202c7490f7db08dbd8442c9db484";
  src = fetchurl {
    url = http://hydra.nixos.org/build/6763096/download/1/dysnomia-0.3pred677260f77bb202c7490f7db08dbd8442c9db484.tar.gz;
    sha256 = "0k7qpqa9inzxjdryd7zfzxid8k1icsxxw995chzw4wrlgxns16xy";
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
     ${if enableMongoDatabase then "--with-mongodb" else "--without-mongodb"}
   '';
  
  buildInputs = []
    ++ stdenv.lib.optional enableEjabberdDump ejabberd
    ++ stdenv.lib.optional enableMySQLDatabase mysql
    ++ stdenv.lib.optional enablePostgreSQLDatabase postgresql
    ++ stdenv.lib.optional enableSubversionRepository subversion
    ++ stdenv.lib.optional enableMongoDatabase mongodb;

  meta = {
    description = "Automated deployment of mutable components and services for Disnix";
    license = "MIT";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
