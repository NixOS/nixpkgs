{ stdenv, lib, sudo, utillinux, coreutils, systemd, cryptsetup,
  buildGoPackage, fetchgit, fetchhg, fetchbzr, fetchsvn }:

buildGoPackage rec {
  name = "interlock-${version}";
  version = "2016.04.13";
  rev = "v${version}";

  goPackagePath = "github.com/inversepath/interlock";

  subPackages = [ "./cmd/interlock" ];

  src = fetchgit {
    inherit rev;
    url = "https://github.com/inversepath/interlock";
    sha256 = "1lnaz0vdg0k21wipc6w8h580cbpymiyasah98yzyzrmwraclb2bb";
  };

  goDeps = ./deps.json;

  nativeBuildInputs = [ sudo ];
  buildFlags = [ "-tags textsecure" ];
  postPatch = ''
    grep -lr '/s\?bin/' | xargs sed -i \
      -e 's|/bin/mount|${utillinux}/bin/mount|' \
      -e 's|/bin/umount|${utillinux}/bin/umount|' \
      -e 's|/bin/cp|${coreutils}/bin/cp|' \
      -e 's|/bin/mv|${coreutils}/bin/mv|' \
      -e 's|/bin/chown|${coreutils}/bin/chown|' \
      -e 's|/bin/date|${coreutils}/bin/date|' \
      -e 's|/sbin/poweroff|${systemd}/sbin/poweroff|' \
      -e 's|/usr/bin/sudo|/var/setuid-wrappers/sudo|' \
      -e 's|/sbin/cryptsetup|${cryptsetup}/bin/cryptsetup|'
  '';
}
