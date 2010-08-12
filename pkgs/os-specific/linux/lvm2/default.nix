{ stdenv, fetchurl, udev }:

let
  v = "2.02.65";
in

stdenv.mkDerivation {
  name = "lvm2-${v}";
  
  src = fetchurl {
    url = "ftp://sources.redhat.com/pub/lvm2/old/LVM2.${v}.tgz";
    sha256 =  "2a4157b91b7ad5ea84359e8548b64947611beea01862e010be71f54b649e7ad1";
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
