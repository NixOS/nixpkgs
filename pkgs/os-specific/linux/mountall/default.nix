{ stdenv, fetchurl, pkgconfig, libnih, dbus, udev, gettext, autoreconfHook }:

stdenv.mkDerivation {
  name = "mountall-2.35";

  src = fetchurl {
    url = https://launchpad.net/ubuntu/+archive/primary/+files/mountall_2.35.tar.gz;
    sha256 = "1k52d4x75balnwcsqgznvzrdqgbp2dqnrzw0n25kajdcwr192wwy";
  };

  patches = [ ./no-plymouth.patch ./fix-usr1-race.patch ];

  buildInputs = [ pkgconfig libnih dbus.libs udev gettext autoreconfHook ];

  makeFlags = "initramfshookdir=$(out)/share/initramfs-tools/hooks upstart_jobs_initramfs_configdir=$(out)/share/initramfs-tools/event-driven/upstart-jobs";

  meta = {
    homepage = https://launchpad.net/ubuntu/+source/mountall;
    description = "Utility to mount all filesystems and emit Upstart events";
    platforms = stdenv.lib.platforms.linux;
  };
}
