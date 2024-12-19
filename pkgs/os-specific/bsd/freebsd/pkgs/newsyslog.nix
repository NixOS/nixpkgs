{
  mkDerivation,
  compatIfNeeded,
  libsbuf,
}:
mkDerivation {
  path = "usr.sbin/newsyslog";

  buildInputs = compatIfNeeded ++ [ libsbuf ];

  # The only subdir is newsyslog.conf.d, all config files we don't want
  postPatch = ''
    sed -E -i -e '/^SUBDIR/d' $BSDSRCDIR/usr.sbin/newsyslog/Makefile
  '';
}
