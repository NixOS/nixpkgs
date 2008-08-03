{stdenv, fetchurl}:

if stdenv.system != "x86_64-linux" || ! (stdenv ? isDietLibC) || !stdenv.isDietLibC then

stdenv.mkDerivation {
  name = "udev-125";

  src = fetchurl {
    url = mirror://kernel/linux/utils/kernel/hotplug/udev-125.tar.bz2;
    sha256 = "1w75c6vaqw8587djd8g380h1jrbj7fx9441bvvy4gj9jz21r00ks";
  };

  # "DESTDIR=/" is a hack to prevent "make install" from trying to
  # mess with /dev.
  preBuild = ''
    makeFlagsArray=(prefix=$out usrbindir=$out/bin usrsbindir=$out/sbin usrlibdir=$out/lib \
      mandir=$out/share/man includedir=$out/include \
      EXTRAS="extras/ata_id extras/cdrom_id extras/edd_id extras/floppy extras/path_id extras/scsi_id extras/usb_id extras/volume_id"
      INSTALL='install -c' DESTDIR=/)
      
    substituteInPlace udev_rules.c --replace /lib/udev $out/lib/udev
  '';

  preInstall = ''
    installFlagsArray=(udevdir=$TMPDIR/dummy)
  '';

  meta = {
    homepage = http://www.kernel.org/pub/linux/utils/kernel/hotplug/udev.html;
    description = "Udev manages the /dev filesystem";
  };
}

else

# for now svn revision 10849 because this works fine with current dietlibc
# this should be fixed (maybe using klibc) or by patching udev somewhen

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
