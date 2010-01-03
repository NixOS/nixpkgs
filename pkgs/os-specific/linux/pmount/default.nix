{stdenv, fetchurl, cryptsetup, dbus, dbus_glib, hal, intltool, ntfs3g, utillinuxng
, mediaDir ? "/media/"
, lockDir ? "/var/lock/pmount"
, whiteList ? "/etc/pmount.allow"
}:

# constraint mention in the configure.ac
assert stdenv.lib.hasSuffix "/" mediaDir;

stdenv.mkDerivation {
  name = "pmount-0.9.20";

  src = fetchurl {
    url = https://alioth.debian.org/frs/download.php/3127/pmount-0.9.20.tar.gz;
    sha256 = "0574d2e805610c179904f5c676b2b93e088906b91bcb76980daa4a8da1d23e8c";
  };

  buildInputs = [ hal intltool utillinuxng ];

  configureFlags = ""
  + " --with-media-dir=${mediaDir}"
  + " --with-lock-dir=${lockDir}"
  + " --with-whitelist=${whiteList}"
  + " --with-mount-prog=${utillinuxng}/bin/mount"
  + " --with-umount-prog=${utillinuxng}/bin/umount"
  + " --with-cryptsetup=${cryptsetup}/sbin/cryptsetup"
  + " --with-mount-ntfs3g=${ntfs3g}/sbin/mount.ntfs-3g"
  + " --enable-hal";

  postConfigure = ''
    # etc/Mafile.am is hardcoded and it does not respect the --prefix option.
    substituteInPlace ./etc/Makefile --replace DESTDIR prefix
    # Do not change ownership & Do not add the set user ID bit
    substituteInPlace ./src/Makefile --replace '-o root -g root -m 4755 ' '-m 755 '
  '';

  meta = {
    homepage = http://pmount.alioth.debian.org/;
    description = "Mount removable devices as normal user";
    license = "GPLv2";
  };
}
