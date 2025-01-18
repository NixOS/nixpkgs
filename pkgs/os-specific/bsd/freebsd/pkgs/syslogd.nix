{ mkDerivation, lib }:
mkDerivation {
  path = "usr.sbin/syslogd";

  extraPaths = [
    "usr.bin/wall"
    "sys/sys"
  ];

  # These want to install some config files which we don't want
  MK_FTP = "no";
  MK_LPR = "no";
  MK_PPP = "no";

  MK_TESTS = "no";

  meta = with lib; {
    description = "FreeBSD syslog daemon";
    maintainers = with maintainers; [ artemist ];
    platforms = platforms.freebsd;
    license = licenses.bsd2;
  };
}
