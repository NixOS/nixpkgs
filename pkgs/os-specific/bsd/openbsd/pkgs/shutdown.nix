{
  mkDerivation,
  reboot,
  wall,
}:
mkDerivation {
  path = "sbin/shutdown";

  postPatch = ''
    sed -i 's/4550/0550/' $BSDSRCDIR/sbin/shutdown/Makefile

    substituteInPlace $BSDSRCDIR/sbin/shutdown/pathnames.h \
      --replace-fail /sbin/halt ${reboot}/bin/halt \
      --replace-fail /sbin/reboot ${reboot}/bin/reboot \
      --replace-fail /usr/bin/wall ${wall}/bin/wall
  '';
}
