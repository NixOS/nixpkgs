{ stdenv, fetchurl, pkgconfig, udev }:

let
  v = "2.02.86";
in

stdenv.mkDerivation {
  name = "lvm2-${v}";
  
  src = fetchurl {
    url = "ftp://sources.redhat.com/pub/lvm2/old/LVM2.${v}.tgz";
    sha256 = "0bam8ampdqn4xx2agrvh5vn4xdi0gb9lmfsm31fm302y52jsyz2m";
  };
  
  configureFlags =
    "--disable-readline --enable-udev_rules --enable-udev_sync --enable-pkgconfig --enable-applib";

  buildInputs = [ pkgconfig udev ];
  
  # To prevent make install from failing.
  preInstall = "installFlags=\"OWNER= GROUP= confdir=$out/etc\"";

  meta = {
    homepage = http://sourceware.org/lvm2/;
    descriptions = "Tools to support Logical Volume Management (LVM) on Linux";
  };
}
