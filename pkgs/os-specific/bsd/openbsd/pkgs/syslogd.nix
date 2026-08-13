{
  mkDerivation,
  libressl,
  libevent,
}:
mkDerivation {
  path = "usr.sbin/syslogd";

  buildInputs = [
    libressl
    libevent
  ];

  postPatch = ''
    sed -i /DPADD/d $BSDSRCDIR/usr.sbin/syslogd/Makefile
  '';
}
