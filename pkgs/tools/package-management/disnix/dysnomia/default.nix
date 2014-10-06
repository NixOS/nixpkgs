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
  name = "dysnomia-0.3preccaebdfad11bc34850b24f1c2cb5ee6c8f0b7fe2";
  src = fetchurl {
    url = http://hydra.nixos.org/build/14156365/download/1/dysnomia-0.3preccaebdfad11bc34850b24f1c2cb5ee6c8f0b7fe2.tar.gz;
    sha256 = "0l88vcpnicw86cn6jwrgmg3fs6i3sw3qc9r6lycfkjf5qrnzd1yi";
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
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
