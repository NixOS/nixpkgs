# FIXME: unify with pkgs/os-specific/linux/multipath-tools/default.nix.

{ stdenv, fetchurl, fetchpatch, lvm2, libaio, gzip, readline, systemd }:

stdenv.mkDerivation rec {
  name = "multipath-tools-0.4.9";

  src = fetchurl {
    url = "http://christophe.varoqui.free.fr/multipath-tools/${name}.tar.bz2";
    sha256 = "04n7kazp1zrlqfza32phmqla0xkcq4zwn176qff5ida4a60whi4d";
  };

  patches = [
    # Fix build with glibc >= 2.28
    # https://github.com/NixOS/nixpkgs/issues/86403
    (fetchpatch {
      url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/sys-fs/multipath-tools/files/multipath-tools-0.6.4-sysmacros.patch?id=eb22b954c177b5c1e2b6ed5c7cdd02f40f40d757";
      sha256 = "1an0cgmz7g03c4qjimhpm9fcf2iswws18lwqxi688k87qm3xb5qd";
      excludes = [
        "libmultipath/util.c"
      ];
    })
  ];

  sourceRoot = ".";

  buildInputs = [ lvm2 libaio readline gzip ];

  preBuild =
    ''
      makeFlagsArray=(GZIP="-9" prefix=$out mandir=$out/share/man/man8 man5dir=$out/share/man/man5 LIB=lib)

      substituteInPlace multipath/Makefile --replace /etc $out/etc
      substituteInPlace kpartx/Makefile --replace /etc $out/etc

      substituteInPlace kpartx/kpartx.rules --replace /sbin/kpartx $out/sbin/kpartx
      substituteInPlace kpartx/kpartx_id --replace /sbin/dmsetup ${lvm2}/sbin/dmsetup

      substituteInPlace libmultipath/defaults.h --replace /lib/udev/scsi_id ${systemd.lib}/lib/udev/scsi_id
      substituteInPlace libmultipath/hwtable.c --replace /lib/udev/scsi_id ${systemd.lib}/lib/udev/scsi_id

      sed -i -re '
         s,^( *#define +DEFAULT_MULTIPATHDIR\>).*,\1 "'"$out/lib/multipath"'",
      ' libmultipath/defaults.h

    '';

  meta = {
    description = "Tools for the Linux multipathing driver";
    homepage = "http://christophe.varoqui.free.fr/";
    platforms = stdenv.lib.platforms.linux;
  };
}
