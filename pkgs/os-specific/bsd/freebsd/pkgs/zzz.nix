{
  lib,
  mkDerivation,
  acpi,
  apm,
  bin,
  gnugrep,
  sysctl,
}:

let
  depsPath = lib.makeBinPath [
    acpi
    apm
    bin
    gnugrep
    sysctl
  ];
in
mkDerivation {
  path = "usr.sbin/zzz";
  postPatch = ''
    sed -E -i -e "s|/bin/sh|${lib.getBin bin}/bin/sh|g" $BSDSRCDIR/usr.sbin/zzz/zzz.sh
    sed -E -i -e "s|PATH=.*|PATH=${depsPath}|g" $BSDSRCDIR/usr.sbin/zzz/zzz.sh
  '';
}
