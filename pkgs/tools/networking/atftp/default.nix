{ stdenv, fetchurl, pcre, readline }:

stdenv.mkDerivation {
  name = "atftp-0.7.1";

  src = fetchurl {
    url = "mirror://sourceforge/atftp/atftp-0.7.1.tar.gz";
    sha256 = "0bgr31gbnr3qx4ixf8hz47l58sh3367xhcnfqd8233fvr84nyk5f";
  };

  buildInputs = [ pcre readline ];

  NIX_LDFLAGS = "-lgcc_s"; # for pthread_cancel

  configureFlags = [
    "--enable-libreadline"
    "--enable-libpcre"
    "--enable-mtftp"
  ];

  meta = with stdenv.lib; {
    description = "Advanced TFTP server and client";
    homepage = http://sourceforge.net/projects/atftp/;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
