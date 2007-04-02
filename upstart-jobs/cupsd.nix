{ writeText, cups
}:

let

  logDir = "/var/log/cups";

  cupsdConfig = writeText "cupsd.conf" "
    LogLevel info

    SystemGroup root

    Listen localhost:631
    Listen /var/run/cups/cups.sock

    ServerRoot ${cups}/etc/cups

    AccessLog ${logDir}/access_log
    ErrorLog ${logDir}/access_log
    PageLog ${logDir}/page_log

    TempDir /tmp

    Browsing On
    BrowseOrder allow,deny
    BrowseAllow @LOCAL

    DefaultAuthType Basic

    <Location />
      Order allow,deny
      Allow localhost
    </Location>
    
    <Location /admin>
      Order allow,deny
      Allow localhost
    </Location>
    
    <Location /admin/conf>
      AuthType Basic
      Require user @SYSTEM
      Order allow,deny
      Allow localhost
    </Location>

    <Policy default>
      <Limit Send-Document Send-URI Hold-Job Release-Job Restart-Job Purge-Jobs Set-Job-Attributes Create-Job-Subscription Renew-Subscription Cancel-Subscription Get-Notifications Reprocess-Job Cancel-Current-Job Suspend-Current-Job Resume-Job CUPS-Move-Job>
        Require user @OWNER @SYSTEM
        Order deny,allow
      </Limit>

      <Limit Pause-Printer Resume-Printer Set-Printer-Attributes Enable-Printer Disable-Printer Pause-Printer-After-Current-Job Hold-New-Jobs Release-Held-New-Jobs Deactivate-Printer Activate-Printer Restart-Printer Shutdown-Printer Startup-Printer Promote-Job Schedule-Job-After CUPS-Add-Printer CUPS-Delete-Printer CUPS-Add-Class CUPS-Delete-Class CUPS-Accept-Jobs CUPS-Reject-Jobs CUPS-Set-Default>
        AuthType Basic
        Require user @SYSTEM
        Order deny,allow
      </Limit>

      <Limit Cancel-Job CUPS-Authenticate-Job>
        Require user @OWNER @SYSTEM
        Order deny,allow
      </Limit>

      <Limit All>
        Order deny,allow
      </Limit>
    </Policy>
  ";

in

{
  name = "cupsd";

  extraPath = [
    cups
  ];
  
  job = "
description \"CUPS daemon\"

start on network-interfaces/started
stop on network-interfaces/stop

start script
    mkdir -m 0755 -p ${logDir}
    mkdir -m 0700 -p /var/cache/cups
    mkdir -m 0700 -p /var/spool/cups
end script
    
respawn ${cups}/sbin/cupsd -c ${cupsdConfig} -F
  ";
  
}
