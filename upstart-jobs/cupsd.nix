{config, pkgs}:

let

  logDir = "/var/log/cups";


  inherit (pkgs) cups;


  # Here we can enable additional backends, filters, etc. that are not
  # part of CUPS itself, e.g. the SMB backend is part of Samba.  Since
  # we can't update ${cups}/lib/cups itself, we create a symlink tree
  # here and add the additional programs.  The ServerBin directive in
  # cupsd.conf tells cupsd to use this tree.
  bindir = pkgs.runCommand "cups-progs" {} ''
    ensureDir $out/lib/cups
    ln -s ${cups}/lib/cups/* $out/lib/cups/
    
    rm $out/lib/cups/backend
    ensureDir $out/lib/cups/backend
    ln -s ${cups}/lib/cups/backend/* $out/lib/cups/backend/
    ln -s ${pkgs.samba}/bin/smbspool $out/lib/cups/backend/smb
  ''; # */
  

  cupsdConfig = pkgs.writeText "cupsd.conf" ''
    LogLevel info

    SystemGroup root

    Listen localhost:631
    Listen /var/run/cups/cups.sock

    ServerRoot ${cups}/etc/cups

    ServerBin ${bindir}/lib/cups

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
  '';

in

{
  name = "cupsd";

  extraPath = [
    cups
  ];
  
  job = ''
    description "CUPS printing daemon"

    start on network-interfaces/started
    stop on network-interfaces/stop

    start script
        mkdir -m 0755 -p ${logDir}
        mkdir -m 0700 -p /var/cache/cups
        mkdir -m 0700 -p /var/spool/cups
    end script

    respawn ${cups}/sbin/cupsd -c ${cupsdConfig} -F
  '';
  
}
