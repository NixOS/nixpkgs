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
    sed -i /DPADD/d $BSDSRCDIR/usr.sbin/syslogd/syslogd/Makefile

    # NetBSD make otherwise mistakes the source directories for built executables.
    for program in syslogd syslogd-parent; do
      echo ".NOPATH: $program" >> "$BSDSRCDIR/usr.sbin/syslogd/$program/Makefile"
    done

    # The daemon and its privileged parent are both installed in $out/bin.
    substituteInPlace "$BSDSRCDIR/usr.sbin/syslogd/privsep.c" \
      --replace-fail '"/sbin/syslogd"' '"/bin/syslogd"' \
      --replace-fail '"/libexec/syslogd-parent"' '"/bin/syslogd-parent"'
  '';
}
