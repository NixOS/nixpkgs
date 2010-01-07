{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "lvm2-2.02.56";
  
  src = fetchurl {
    url = ftp://sources.redhat.com/pub/lvm2/LVM2.2.02.56.tgz;
    sha256 = "0hrgca93jnc3k05cgc3rc5klvc03anxmqydgljv6qq59nhnfz5lw";
  };
  
  configureFlags = "--disable-readline --enable-udev_rules --enable-udev_sync";
  
  # To prevent make install from failing.
  preInstall = "installFlags=\"OWNER= GROUP= confdir=$out/etc\"";

  meta = {
    homepage = http://sourceware.org/lvm2/;
    descriptions = "Tools to support Logical Volume Management (LVM) on Linux";
  };
}
