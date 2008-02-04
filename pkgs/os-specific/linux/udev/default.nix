{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "udev-118";

  src = fetchurl {
    url = mirror://kernel/linux/utils/kernel/hotplug/udev-118.tar.bz2;
    sha256 = "1i488wqm7i6nz6gidbkxkb47hr427ika48i8imwrvvnpg1kzhska";
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
