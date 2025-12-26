{
  mkDerivation,
}:
mkDerivation {
  pname = "rc";
  path = "etc";

  patches = [
    ./boot-phases.patch
    ./binsh-is-bash.patch
  ];

  buildPhase = ":";

  installPhase = ''
    mkdir -p $out/etc/rc.d
    cp rc $out/etc
    cp rc.d/rc.subr $out/etc/rc.d
    chmod +x $out/etc/rc
  '';
}
