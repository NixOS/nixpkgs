{ stdenv, fetchurl, cryptsetup, dbus, dbus_glib, intltool, ntfs3g, utillinux
, mediaDir ? "/media/"
, lockDir ? "/var/lock/pmount"
, whiteList ? "/etc/pmount.allow"
}:

# constraint mention in the configure.ac
assert stdenv.lib.hasSuffix "/" mediaDir;

stdenv.mkDerivation rec {
  name = "pmount-${version}";
  version = "0.9.23";

  src = fetchurl {
    url = "https://launchpad.net/ubuntu/trusty/+source/pmount/0.9.23-2/+files/pmount_${version}.orig.tar.bz2";
    sha256 = "0dm01sh5nnf2bk0jc0z87qxy2hbxcbxs4ba4kng8w3ki1clzqf6v";
  };

  buildInputs = [ intltool utillinux ];

  configureFlags = ""
  + " --with-media-dir=${mediaDir}"
  + " --with-lock-dir=${lockDir}"
  + " --with-whitelist=${whiteList}"
  + " --with-mount-prog=${utillinux}/bin/mount"
  + " --with-umount-prog=${utillinux}/bin/umount"
  + " --with-mount-ntfs3g=${ntfs3g}/sbin/mount.ntfs-3g";

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
    platforms = stdenv.lib.platforms.linux;
  };
}
