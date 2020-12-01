{stdenv, fetchurl, perl}:

stdenv.mkDerivation {
  name = "daemon-0.7";
  src = fetchurl {
    url = "http://libslack.org/daemon/download/daemon-0.7.tar.gz";
    sha256 = "0b17zzl7bqnkn7a4pr3l6fxqfmxfld7izphrab5nvhc4wzng4spn";
  };
  makeFlags = [ "PREFIX=$(out)" ];
  buildInputs = [ perl ];

  meta = {
    description = "Turns other processes into daemons";
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
