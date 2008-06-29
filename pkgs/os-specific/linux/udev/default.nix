{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "udev-124";

  src = fetchurl {
    url = mirror://kernel/linux/utils/kernel/hotplug/udev-124.tar.bz2;
    sha256 = "0hjmg82ivczm76kg9gm7x0sfji69bwwjbbfycfcdpnfrc13935x4";
  };

  # "DESTDIR=/" is a hack to prevent "make install" from trying to
  # mess with /dev.
  preBuild = ''
    makeFlagsArray=(etcdir=$out/etc sbindir=$out/sbin usrbindir=$out/bin usrsbindir=$out/sbin mandir=$out/share/man INSTALL='install -c' DESTDIR=/)
  '';

  preInstall = ''
    installFlagsArray=(udevdir=$TMPDIR/dummy)
  '';

  meta = {
    homepage = http://www.kernel.org/pub/linux/utils/kernel/hotplug/udev.html;
    description = "Udev manages the /dev filesystem";
  };
}
