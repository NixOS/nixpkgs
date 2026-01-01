<<<<<<< HEAD
{
  mkDerivation,
  lib,
  libcasper,
  libcapsicum,
  libnv,
}:
=======
{ mkDerivation, lib }:
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
mkDerivation {
  path = "usr.sbin/syslogd";

  extraPaths = [
    "usr.bin/wall"
    "sys/sys"
  ];

<<<<<<< HEAD
  buildInputs = [
    libcasper
    libcapsicum
    libnv
  ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  # These want to install some config files which we don't want
  MK_FTP = "no";
  MK_LPR = "no";
  MK_PPP = "no";

  MK_TESTS = "no";

  meta = {
    description = "FreeBSD syslog daemon";
    maintainers = with lib.maintainers; [ artemist ];
    platforms = lib.platforms.freebsd;
    license = lib.licenses.bsd2;
  };
}
