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
, getopt
}:

assert enableMySQLDatabase -> mysql != null;
assert enablePostgreSQLDatabase -> postgresql != null;
assert enableSubversionRepository -> subversion != null;
assert enableEjabberdDump -> ejabberd != null;
assert enableMongoDatabase -> mongodb != null;

stdenv.mkDerivation {
  name = "dysnomia-0.3pre09cc08f5ffc737d988923bb7329a7ec711badd82";
  src = fetchurl {
    url = http://hydra.nixos.org/build/11407191/download/1/dysnomia-0.3pre09cc08f5ffc737d988923bb7329a7ec711badd82.tar.gz;
    sha256 = "1i7yb299bq1z7cy4sk83m5faahj8inh73xn5bi6jcv492zv3kgwz";
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
  
  buildInputs = [ getopt ]
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
