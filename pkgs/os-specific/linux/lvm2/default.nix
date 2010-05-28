{ stdenv, fetchurl, udev }:

let
  v = "2.02.65";
in

stdenv.mkDerivation {
  name = "lvm2-${v}";
  
  src = fetchurl {
    url = "ftp://sources.redhat.com/pub/lvm2/LVM2.${v}.tgz";
    sha256 = "1lbskrj4pxbipq8f0qhql3p1nqa796v4i1cy6n2fmmbs3fwmfh9a";
  };
  
  configureFlags = "--disable-readline --enable-udev_rules --enable-udev_sync";

  buildInputs = [ udev ];
  
  # To prevent make install from failing.
  preInstall = "installFlags=\"OWNER= GROUP= confdir=$out/etc\"";

  meta = {
    homepage = http://sourceware.org/lvm2/;
    descriptions = "Tools to support Logical Volume Management (LVM) on Linux";
  };
}
