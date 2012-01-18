{stdenv, fetchurl, sendmailPath ? "/usr/sbin/sendmail"}:

stdenv.mkDerivation {
  name = "cron-4.1";
  src = fetchurl {
    url = ftp://ftp.isc.org/isc/cron/cron_4.1.shar;
    md5 = "5e1be9dbde66295821ac7899f2e1f561";
  };

  unpackCmd = "(mkdir cron && cd cron && sh $curSrc)";

  preBuild = ''
    substituteInPlace Makefile --replace ' -o root' ' ' --replace 111 755
    makeFlags="DESTROOT=$out"

    # We want to ignore the $glibc/include/paths.h definition of
    # sendmail path
    echo "#undef _PATH_SENDMAIL" >> pathnames.h
    echo '#define _PATH_SENDMAIL "${sendmailPath}"' >> pathnames.h
  '';

  preInstall = "mkdir -p $out/bin $out/sbin $out/share/man/man1 $out/share/man/man5 $out/share/man/man8";
  
  meta = {
    description = "Vixie Cron, a daemon for running commands at specific times";
  };
}
