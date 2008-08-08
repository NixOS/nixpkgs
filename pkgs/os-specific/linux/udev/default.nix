{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "udev-125";

  src = fetchurl {
    url = mirror://kernel/linux/utils/kernel/hotplug/udev-125.tar.bz2;
    sha256 = "1w75c6vaqw8587djd8g380h1jrbj7fx9441bvvy4gj9jz21r00ks";
  };

  # "DESTDIR=/" is a hack to prevent "make install" from trying to
  # mess with /dev.
  preBuild =
    ''
      makeFlagsArray=(prefix=$out usrbindir=$out/bin usrsbindir=$out/sbin usrlibdir=$out/lib \
        mandir=$out/share/man includedir=$out/include \
        EXTRAS="extras/volume_id extras/ata_id extras/edd_id extras/floppy extras/path_id extras/scsi_id extras/usb_id ${if stdenv ? isKlibc then "" else "extras/cdrom_id"}"
        INSTALL='install -c' DESTDIR=/ \
        ${if stdenv ? isStatic then "USE_STATIC=true SHLIB= VOLUME_ID_STATIC=true" else ""})
      
      substituteInPlace udev_rules.c --replace /lib/udev $out/lib/udev
  ''

  + (if stdenv ? isStatic then
    ''
      # `make install' would cause the shared library to be installed, which we don't build.
      substituteInPlace extras/volume_id/lib/Makefile  --replace 'install:' 'disabled:'
    '' else "");

  preInstall = ''
    installFlagsArray=(udevdir=$TMPDIR/dummy)
  '';

  meta = {
    homepage = http://www.kernel.org/pub/linux/utils/kernel/hotplug/udev.html;
    description = "Udev manages the /dev filesystem";
  };
}
