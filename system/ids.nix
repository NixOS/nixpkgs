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

    nixbld = 30000; # start of range of uids
    nobody = 65534;
  };

  gids = {
    root = 0;
    wheel = 1;
    haldaemon = 5;
    vsftpd = 7;
    ftp = 8;
    bitlbee = 9;
    avahi = 10;
    portmap = 11;
    atd = 12;

    audio = 17;

    users = 100;
    nixbld = 30000;
    nogroup = 65534;
  };

}
