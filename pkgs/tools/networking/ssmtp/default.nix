{stdenv, fetchurl, tlsSupport ? false, openssl ? null}:

assert tlsSupport -> openssl != null;

stdenv.mkDerivation {
  name = "ssmtp-2.64";
  
  src = fetchurl {
    url = http://ftp.debian.org/debian/pool/main/s/ssmtp/ssmtp_2.64.orig.tar.bz2;
    sha256 = "0dps8s87ag4g3jr6dk88hs9zl46h3790marc5c2qw7l71k4pvhr2";
  };

  configureFlags = "--sysconfdir=/etc ${if tlsSupport then "--enable-ssl" else ""}";

  postConfigure =
    ''
      # Don't run the script that interactively generates a config file.
      # Also don't install the broken, cyclic symlink /lib/sendmail.
      sed -e '/INSTALLED_CONFIGURATION_FILE/d' \
          -e 's|/lib/sendmail|$(TMPDIR)/sendmail|' \
          -i Makefile
    '';

  installFlags = "etcdir=$(out)/etc";

  installTargets = [ "install" "install-sendmail" ];
  
  buildInputs = stdenv.lib.optional tlsSupport openssl;
}
