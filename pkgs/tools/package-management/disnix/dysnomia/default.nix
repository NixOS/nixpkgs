{ lib, stdenv, fetchurl, netcat
, systemd ? null, ejabberd ? null, mysql ? null, postgresql ? null, subversion ? null, mongodb ? null, mongodb-tools ? null, influxdb ? null, supervisor ? null, docker ? null
, enableApacheWebApplication ? false
, enableAxis2WebService ? false
, enableEjabberdDump ? false
, enableMySQLDatabase ? false
, enablePostgreSQLDatabase ? false
, enableSubversionRepository ? false
, enableTomcatWebApplication ? false
, enableMongoDatabase ? false
, enableInfluxDatabase ? false
, enableSupervisordProgram ? false
, enableDockerContainer ? true
, enableLegacy ? false
, catalinaBaseDir ? "/var/tomcat"
, jobTemplate ? "systemd"
, getopt
}:

assert enableMySQLDatabase -> mysql != null;
assert enablePostgreSQLDatabase -> postgresql != null;
assert enableSubversionRepository -> subversion != null;
assert enableEjabberdDump -> ejabberd != null;
assert enableMongoDatabase -> (mongodb != null && mongodb-tools != null);
assert enableInfluxDatabase -> influxdb != null;
assert enableSupervisordProgram -> supervisor != null;
assert enableDockerContainer -> docker != null;

stdenv.mkDerivation {
  name = "dysnomia-0.10";
  src = fetchurl {
    url = "https://github.com/svanderburg/dysnomia/releases/download/dysnomia-0.10/dysnomia-0.10.tar.gz";
    sha256 = "19zg4nhn0f9v4i7c9hhan1i4xv3ljfpl2d0s84ph8byiscvhyrna";
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
     (if enableInfluxDatabase then "--with-influxdb" else "--without-influxdb")
     (if enableSupervisordProgram then "--with-supervisord" else "--without-supervisord")
     (if enableDockerContainer then "--with-docker" else "--without-docker")
     "--with-job-template=${jobTemplate}"
   ] ++ lib.optional enableLegacy "--enable-legacy";

  buildInputs = [ getopt netcat ]
    ++ lib.optional stdenv.isLinux systemd
    ++ lib.optional enableEjabberdDump ejabberd
    ++ lib.optional enableMySQLDatabase mysql.out
    ++ lib.optional enablePostgreSQLDatabase postgresql
    ++ lib.optional enableSubversionRepository subversion
    ++ lib.optional enableMongoDatabase mongodb
    ++ lib.optional enableMongoDatabase mongodb-tools
    ++ lib.optional enableInfluxDatabase influxdb
    ++ lib.optional enableSupervisordProgram supervisor
    ++ lib.optional enableDockerContainer docker;

  meta = {
    description = "Automated deployment of mutable components and services for Disnix";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sander ];
    platforms = lib.platforms.unix;
  };
}
