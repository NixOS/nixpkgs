{stdenv, fetchurl, tlsSupport ? true, openssl ? null}:

assert tlsSupport -> openssl != null;

stdenv.mkDerivation {
  name = "ssmtp-2.64";

  src = fetchurl {
    url = mirror://debian/pool/main/s/ssmtp/ssmtp_2.64.orig.tar.bz2;
    sha256 = "0dps8s87ag4g3jr6dk88hs9zl46h3790marc5c2qw7l71k4pvhr2";
  };

  # A request has been made to merge this patch into ssmtp.
  # See: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=858781
  patches = [ ./ssmtp_support_AuthPassFile_parameter.patch ];

  configureFlags = [
    "--sysconfdir=/etc"
    (stdenv.lib.enableFeature tlsSupport "ssl")
  ];

  postConfigure =
    ''
      # Don't run the script that interactively generates a config file.
      # Also don't install the broken, cyclic symlink /lib/sendmail.
      sed -e '/INSTALLED_CONFIGURATION_FILE/d' \
          -e 's|/lib/sendmail|$(TMPDIR)/sendmail|' \
          -i Makefile
      substituteInPlace Makefile \
        --replace '$(INSTALL) -s' '$(INSTALL) -s --strip-program $(STRIP)'
    '';

  installFlags = [ "etcdir=$(out)/etc" ];

  installTargets = [ "install" "install-sendmail" ];

  buildInputs = stdenv.lib.optional tlsSupport openssl;

  NIX_LDFLAGS = stdenv.lib.optionalString tlsSupport "-lcrypto";

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = with maintainers; [ basvandijk ];
  };
}
