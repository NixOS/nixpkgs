{ stdenv, fetchurl
, ejabberd ? null, mysql ? null, postgresql ? null, subversion ? null, mongodb ? null, mongodb-tools ? null
, enableApacheWebApplication ? false
, enableAxis2WebService ? false
, enableEjabberdDump ? false
, enableMySQLDatabase ? false
, enablePostgreSQLDatabase ? false
, enableSubversionRepository ? false
, enableTomcatWebApplication ? false
, enableMongoDatabase ? false
, catalinaBaseDir ? "/var/tomcat"
, jobTemplate ? "systemd"
, getopt
}:

assert enableMySQLDatabase -> mysql != null;
assert enablePostgreSQLDatabase -> postgresql != null;
assert enableSubversionRepository -> subversion != null;
assert enableEjabberdDump -> ejabberd != null;
assert enableMongoDatabase -> (mongodb != null && mongodb-tools != null);

stdenv.mkDerivation {
  name = "dysnomia-0.7.1";
  src = fetchurl {
    url = https://github.com/svanderburg/dysnomia/files/1576949/dysnomia-0.7.1.tar.gz;
    sha256 = "0fyyn6654p10mrm2rlgv017d74wjb8z9h2xzv8gwdly34kifj9dh";
  };

  preConfigure = if enableEjabberdDump then "export PATH=$PATH:${ejabberd}/sbin" else "";
  
  configureFlags = [
     (if enableApacheWebApplication then "--with-apache" else "--without-apache")
     (if enableAxis2WebService then "--with-axis2" else "--without-axis2")
     (if enableEjabberdDump then "--with-ejabberd" else "--without-ejabberd")
     (if enableMySQLDatabase then "--with-mysql" else "--without-mysql")
     (if enablePostgreSQLDatabase then "--with-postgresql" else "--without-postgresql")
     (if enableSubversionRepository then "--with-subversion" else "--without-subversion")
     (if enableTomcatWebApplication then "--with-tomcat=${catalinaBaseDir}" else "--without-tomcat")
     (if enableMongoDatabase then "--with-mongodb" else "--without-mongodb")
     "--with-job-template=${jobTemplate}"
   ];
  
  buildInputs = [ getopt ]
    ++ stdenv.lib.optional enableEjabberdDump ejabberd
    ++ stdenv.lib.optional enableMySQLDatabase mysql.out
    ++ stdenv.lib.optional enablePostgreSQLDatabase postgresql
    ++ stdenv.lib.optional enableSubversionRepository subversion
    ++ stdenv.lib.optional enableMongoDatabase mongodb
    ++ stdenv.lib.optional enableMongoDatabase mongodb-tools;

  meta = {
    description = "Automated deployment of mutable components and services for Disnix";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.sander ];
    platforms = stdenv.lib.platforms.unix;
  };
}
