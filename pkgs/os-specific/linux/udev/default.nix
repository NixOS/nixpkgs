{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "udev-112";
  src = fetchurl {
    url = http://www.us.kernel.org/pub/linux/utils/kernel/hotplug/udev-112.tar.bz2;
    sha256 = "0vhqnli4va3yzvr90rcpbgs42sphpk9prdis9x2qmlmdynzangw2";
  };
  preBuild = "makeFlagsArray=(etcdir=$out/etc sbindir=$out/sbin usrbindir=$out/bin usrsbindir=$out/sbin mandir=$out/share/man INSTALL='install -c')";
  preInstall = "installFlagsArray=(udevdir=dummy)";
}
