{pkgs, glibc, pwdutils}:

let

  user = "wwwrun";
  group = "wwwrun";

  webServer = import ../services/apache-httpd {
    inherit (pkgs) apacheHttpd coreutils;
    stdenv = pkgs.stdenvNew;

    hostName = "localhost";
    httpPort = 80;

    inherit user group;
    
    adminAddr = "eelco@cs.uu.nl";

    logDir = "/var/log/httpd";
    stateDir = "/var/run/httpd";

    subServices = [];
  };

in

{
  name = "httpd";
  
  job = "
description \"Apache HTTPD\"

start on network-interfaces/started
stop on network-interfaces/stop

start script
    if ! ${glibc}/bin/getent group ${group} > /dev/null; then
        ${pwdutils}/sbin/groupadd ${group}
    fi

    if ! ${glibc}/bin/getent passwd ${user} > /dev/null; then
        ${pwdutils}/sbin/useradd -g ${group} -d /var/empty -s /noshell \\
            -c 'Apache httpd user' ${user}
    fi
end script

exec ${webServer}/bin/control start
  ";
  
}
