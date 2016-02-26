{stdenv, fetchurl, sendmailPath ? "/usr/sbin/sendmail"}:

stdenv.mkDerivation {
  name = "cron-4.1";
  src = fetchurl {
    url = ftp://ftp.isc.org/isc/cron/cron_4.1.shar;
    sha256 = "16n3dras4b1jh7g958nz1k54pl9pg5fwb3fvjln8z67varvq6if4";
  };

  unpackCmd = "(mkdir cron && cd cron && sh $curSrc)";

  hardening_pie = true;

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
    description = "Daemon for running commands at specific times (Vixie Cron)";
    platforms = stdenv.lib.platforms.linux;
  };
}
