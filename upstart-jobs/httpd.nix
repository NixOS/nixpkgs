{config, pkgs, glibc, pwdutils}:

let

  getCfg = option: config.get ["services" "httpd" option];

  user = getCfg "user";
  group = getCfg "group";

  webServer = import ../services/apache-httpd {
    inherit (pkgs) apacheHttpd coreutils;
    stdenv = pkgs.stdenvNew;

    hostName = getCfg "hostName";
    httpPort = getCfg "httpPort";
    httpsPort = getCfg "httpsPort";

    inherit user group;
    
    adminAddr = getCfg "adminAddr";

    logDir = getCfg "logDir";
    stateDir = getCfg "stateDir";

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

    ${webServer}/bin/control prepare    
end script

respawn ${webServer}/bin/control run
  ";
  
}
