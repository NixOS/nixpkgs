args: with args;
stdenv.mkDerivation {
  name = "tcp-wrappers-7.6";

  src = fetchurl {
    url = http://ftp.debian.org/debian/pool/main/t/tcp-wrappers/tcp-wrappers_7.6.dbs.orig.tar.gz;
    sha256 = "0k68ziinx6biwar5lcb9jvv0rp6b3vmj6861n75bvrz4w1piwkdp";
  };
  
  # we need to set REAL_DAEMON_DIR somehow. I'm getting compilation errors
  # I've managed to compile tcpd manually using 
  # make CFLAGS='-DSYS_ERRLIST_DEFINED=1  -Dvsyslog=1' tcpd
  # see Makefile target all for details

  postUnpack="cd upstream/tarballs; tar xfz *; cd tcp_wrappers_7.6;
    sed -i -e 's=#REAL_DAEMON_DIR=/usr/sbin=REAL_DAEMON_DIR=/usr/sbin=' Makefile
          ";

  buildPhase="
    make CFLAGS='-DSYS_ERRLIST_DEFINED=1  -Dvsyslog=1' tcpd
  "

  buildInputs = [kernelHeaders gnused];

  # meta = ...
}
