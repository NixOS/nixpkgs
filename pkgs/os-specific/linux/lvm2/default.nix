{ stdenv, fetchurl, pkgconfig, udev }:

let
  v = "2.02.95";
in

stdenv.mkDerivation {
  name = "lvm2-${v}";

  src = fetchurl {
    url = "ftp://sources.redhat.com/pub/lvm2/old/LVM2.${v}.tgz";
    sha256 = "09cixpdrbzjybf8k8f0rsgkriyvbaj2acmfsg1bzxnjil4vayd83";
  };

  configureFlags =
    "--disable-readline --enable-udev_rules --enable-udev_sync --enable-pkgconfig --enable-applib";

  buildInputs = [ pkgconfig udev ];

  patches = [ ./purity.patch ];

  # To prevent make install from failing.
  preInstall = "installFlags=\"OWNER= GROUP= confdir=$out/etc\"";

  meta = {
    homepage = http://sourceware.org/lvm2/;
    descriptions = "Tools to support Logical Volume Management (LVM) on Linux";
    platforms = stdenv.lib.platforms.linux;
  };
}
