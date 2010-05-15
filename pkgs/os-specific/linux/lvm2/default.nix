{ stdenv, fetchurl, udev }:

let
  v = "2.02.64";
in

stdenv.mkDerivation {
  name = "lvm2-${v}";
  
  src = fetchurl {
    url = "ftp://sources.redhat.com/pub/lvm2/LVM2.${v}.tgz";
    sha256 = "130yg8a9l0266hraklalm2k26n25a8kb2nvhj13cnczfxbz5a4m0";
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
