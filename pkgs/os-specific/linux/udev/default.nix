{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "udev-103";
  src = fetchurl {
    url = http://www.us.kernel.org/pub/linux/utils/kernel/hotplug/udev-103.tar.bz2;
    md5 = "7360ce47b5ec3f9fa71f18071ecb8b97";
  };
  preBuild = "makeFlagsArray=(etcdir=$out/etc sbindir=$out/sbin usrbindir=$out/bin usrsbindir=$out/sbin mandir=$out/share/man INSTALL='install -c')";
  preInstall = "installFlagsArray=(\"\${makeFlagsArray[@]}\" udevdir=dummy)";
}
