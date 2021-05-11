{ lib, stdenv, fetchurl, netcat

# Optional packages
, systemd ? null, ejabberd ? null, mysql ? null, postgresql ? null, subversion ? null
, mongodb ? null, mongodb-tools ? null, influxdb ? null, supervisor ? null, docker ? null
, nginx ? null, s6-rc ? null, xinetd ? null

# Configuration flags
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
, enableDockerContainer ? false
, enableNginxWebApplication ? false
, enableXinetdService ? false
, enableS6RCService ? false
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
assert enableNginxWebApplication -> nginx != null;
assert enableS6RCService -> s6-rc != null;
assert enableXinetdService -> xinetd != null;

stdenv.mkDerivation {
  name = "dysnomia-0.10.1";
  src = fetchurl {
    url = "https://github.com/svanderburg/dysnomia/releases/download/dysnomia-0.10.1/dysnomia-0.10.1.tar.gz";
    sha256 = "0w9601g8zpaxrmynx6mh8zz85ldpb8psp7cc6ls8v3srjpj1l5n3";
  };

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
     (if enableNginxWebApplication then "--with-nginx" else "--without-nginx")
     (if enableXinetdService then "--with-xinetd" else "--without-xinetd")
     (if enableS6RCService then "--with-s6-rc" else "--without-s6-rc")
     (if stdenv.isDarwin then "--with-launchd" else "--without-launchd")
     "--with-job-template=${jobTemplate}"
   ] ++ stdenv.lib.optional enableLegacy "--enable-legacy";

  buildInputs = [ getopt netcat ]
    ++ lib.optional stdenv.isLinux systemd
    ++ lib.optional enableEjabberdDump ejabberd
    ++ lib.optional enableMySQLDatabase mysql.out
    ++ lib.optional enablePostgreSQLDatabase postgresql
    ++ lib.optional enableSubversionRepository subversion
    ++ lib.optionals enableMongoDatabase [ mongodb mongodb-tools ]
    ++ lib.optional enableInfluxDatabase influxdb
    ++ lib.optional enableSupervisordProgram supervisor
    ++ lib.optional enableDockerContainer docker
    ++ lib.optional enableNginxWebApplication nginx
    ++ lib.optional enableS6RCService s6-rc
    ++ lib.optional enableXinetdService xinetd;

  meta = {
    description = "Automated deployment of mutable components and services for Disnix";
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.sander ];
    platforms = stdenv.lib.platforms.unix;
  };
}
