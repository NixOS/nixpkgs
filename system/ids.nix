{

  uids = {
    root = 0;
    nscd = 1;
    sshd = 2;
    ntp = 3;
    messagebus = 4; # D-Bus
    haldaemon = 5;
    nixbld = 30000; # start of range of uids
    nobody = 65534;
  };

  gids = {
    root = 0;
    users = 100;
    nixbld = 30000;
    nogroup = 65534;
  };

}
