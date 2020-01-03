{stdenv, fetchurl, perl}:

stdenv.mkDerivation {
  name = "daemon-0.6.4";
  src = fetchurl {
    url = http://libslack.org/daemon/download/daemon-0.6.4.tar.gz;
    sha256 = "18aw0f8k3j30xqwv4z03962kdpqd10nf1w9liihylmadlx5fmff4";
  };
  makeFlags = [ "PREFIX=$(out)" ];
  buildInputs = [ perl ];

  meta = {
    description = "Daemon turns other process into daemons";
    longDescription = ''
      Daemon turns other process into daemons. There are many tasks that need
      to be performed to correctly set up a daemon process. This can be tedious.
      Daemon performs these tasks for other processes. This is useful for
      writing daemons in languages other than C, C++ or Perl (e.g. /bin/sh,
      Java).
    '';
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
    platforms = stdenv.lib.platforms.unix;
  };
}
