{ stdenv, fetchurl, lvm2, libaio, gzip, readline, systemd }:

stdenv.mkDerivation rec {
  name = "multipath-tools-0.4.9";

  src = fetchurl {
    url = "http://christophe.varoqui.free.fr/multipath-tools/${name}.tar.bz2";
    sha256 = "04n7kazp1zrlqfza32phmqla0xkcq4zwn176qff5ida4a60whi4d";
  };

  sourceRoot = ".";

  buildInputs = [ lvm2 libaio readline ];

  preBuild =
    ''
      makeFlagsArray=(GZIP="${gzip}/bin/gzip -9 -c" prefix=$out mandir=$out/share/man/man8 man5dir=$out/share/man/man5 LIB=lib)
      
      substituteInPlace multipath/Makefile --replace /etc $out/etc
      substituteInPlace kpartx/Makefile --replace /etc $out/etc
      
      substituteInPlace kpartx/kpartx.rules --replace /sbin/kpartx $out/sbin/kpartx
      substituteInPlace kpartx/kpartx_id --replace /sbin/dmsetup ${lvm2}/sbin/dmsetup

      substituteInPlace libmultipath/defaults.h --replace /lib/udev/scsi_id ${systemd.udev.lib}/lib/udev/scsi_id
      substituteInPlace libmultipath/hwtable.c --replace /lib/udev/scsi_id ${systemd.udev.lib}/lib/udev/scsi_id
    '';

  meta = {
    description = "Tools for the Linux multipathing driver";
    homepage = http://christophe.varoqui.free.fr/;
    platforms = stdenv.lib.platforms.linux;
  };
}
