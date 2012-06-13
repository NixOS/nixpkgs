{stdenv, fetchurl, openssl, pam, bzip2, zlib}:

stdenv.mkDerivation rec {
  name = "dovecot-2.1.7";

  buildInputs = [openssl pam bzip2 zlib];

  src = fetchurl {
    url = "http://dovecot.org/releases/2.1/${name}.tar.gz";
    sha256 = "0lpldhs0nvy6rxabqkp14wzcwf1cx4jvnbp1xcm74izrzxhvrdym";
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
