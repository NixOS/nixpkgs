{

  uids = {
    root = 0;
    nscd = 1;
    sshd = 2;
    ntp = 3;
    messagebus = 4; # D-Bus
    haldaemon = 5;
    nagios = 6;
    vsftpd = 7;
    ftp = 8;
    bitlbee = 9;
    avahi = 10;
    portmap = 11;
    atd = 12;
    zabbix = 13;
    postfix = 14;
    dovecot = 15;
    tomcat = 16;
    gnunetd = 17;

    nixbld = 30000; # start of range of uids
    nobody = 65534;
  };

  gids = {
    root = 0;
    wheel = 1;
    kmem = 2;
    tty = 3;
    haldaemon = 5;
    disk = 6;
    vsftpd = 7;
    ftp = 8;
    bitlbee = 9;
    avahi = 10;
    portmap = 11;
    atd = 12;
    postfix = 13;
    postdrop = 14;
    dovecot = 15;
    audio = 17;
    floppy = 18;
    uucp = 19;
    lp = 20;
    tomcat = 21;
    
    users = 100;
    nixbld = 30000;
    nogroup = 65534;
  };

}
