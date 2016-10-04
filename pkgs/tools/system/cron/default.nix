{stdenv, fetchurl, sendmailPath ? "/usr/sbin/sendmail"}:

stdenv.mkDerivation {
  name = "cron-4.1";
  src = fetchurl {
    url = ftp://ftp.isc.org/isc/cron/cron_4.1.shar;
    sha256 = "16n3dras4b1jh7g958nz1k54pl9pg5fwb3fvjln8z67varvq6if4";
  };

  unpackCmd = "(mkdir cron && cd cron && sh $curSrc)";

  hardeningEnable = [ "pie" ];

  preBuild = ''
    substituteInPlace Makefile --replace ' -o root' ' ' --replace 111 755
    makeFlags="DESTROOT=$out"

    # We want to ignore the $glibc/include/paths.h definition of
    # sendmail path.
    # Also set a usable default PATH (#16518).
    cat >> pathnames.h <<__EOT__
    #undef _PATH_SENDMAIL
    #define _PATH_SENDMAIL "${sendmailPath}"

    #undef _PATH_DEFPATH
    #define _PATH_DEFPATH "/var/setuid-wrappers:/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:/run/current-system/sw/bin:/run/current-system/sw/sbin:/usr/bin:/bin"
    __EOT__

    # Implicit saved uids do not work here due to way NixOS uses setuid wrappers
    # (#16518).
    echo "#undef HAVE_SAVED_UIDS" >> externs.h
  '';

  preInstall = "mkdir -p $out/bin $out/sbin $out/share/man/man1 $out/share/man/man5 $out/share/man/man8";

  meta = {
    description = "Daemon for running commands at specific times (Vixie Cron)";
    platforms = stdenv.lib.platforms.linux;
  };
}
