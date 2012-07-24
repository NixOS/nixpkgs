{stdenv, fetchurl, openssl, pam, bzip2, zlib}:

stdenv.mkDerivation rec {
  name = "dovecot-2.1.8";

  buildInputs = [openssl pam bzip2 zlib];

  src = fetchurl {
    url = "http://dovecot.org/releases/2.1/${name}.tar.gz";
    sha256 = "03801f4agcwdpqyg6dfxlga3750pnhk4gaf8m7sjq1qmz2277028";
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
