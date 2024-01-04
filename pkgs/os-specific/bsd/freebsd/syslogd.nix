{ mkDerivation, lib, stdenv, ... }:
mkDerivation {
  path = "usr.sbin/syslogd";

  extraPaths = [ "usr.bin/wall" "sys/sys" ];

  # These want to install some config files which we don't want
  MK_FTP = "no";
  MK_LPR = "no";
  MK_PPP = "no";

  MK_TESTS = "no";
  preBuild = lib.optionalString stdenv.cc.isClang ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -D_VA_LIST -D_VA_LIST_DECLARED -Dva_list=__builtin_va_list -D_SIZE_T -D_WCHAR_T"
  '';

  meta = with lib; {
    description = "FreeBSD syslog daemon";
    maintainers = with maintainers; [ artemist ];
    platforms = platforms.freebsd;
    license = licenses.bsd2;
  };
}
