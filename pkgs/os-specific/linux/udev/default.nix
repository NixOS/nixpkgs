{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "udev-118";
  src = fetchurl {
    url = mirror://kernel/linux/utils/kernel/hotplug/udev-118.tar.bz2;
    sha256 = "1i488wqm7i6nz6gidbkxkb47hr427ika48i8imwrvvnpg1kzhska";
  };
  preBuild = "makeFlagsArray=(etcdir=$out/etc sbindir=$out/sbin usrbindir=$out/bin usrsbindir=$out/sbin mandir=$out/share/man INSTALL='install -c')";
  preInstall = "installFlagsArray=(udevdir=dummy)";
}
