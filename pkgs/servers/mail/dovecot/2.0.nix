{stdenv, fetchurl, openssl, pam, bzip2, zlib}:

stdenv.mkDerivation {
  name = "dovecot-2.0.15";

  buildInputs = [openssl pam bzip2 zlib];

  src = fetchurl {
    url = http://dovecot.org/releases/2.0/dovecot-2.0.15.tar.gz;
    sha256 = "03byp6alxxk65qfjjnqp6kcncs5cdiqgskx90nk9kcnynl1h6r33";
  };

  # It will hardcode this for /var/lib/dovecot.
  # http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=626211
  configureFlags = [ "--localstatedir=/var" ];

  meta = {
    homepage = http://dovecot.org/;
    description = "Open source IMAP and POP3 email server written with security primarily in mind";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
  
}
