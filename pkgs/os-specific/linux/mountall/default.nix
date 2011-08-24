{ stdenv, fetchurl, pkgconfig, libnih, dbus, udev, autoconf, automake, libtool, gettext }:
   
stdenv.mkDerivation {
  name = "mountall-2.31";
   
  src = fetchurl {
    url = https://launchpad.net/ubuntu/+archive/primary/+files/mountall_2.31.tar.gz;
    sha256 = "09885v82kd8x7yf18vw7h6z4816jvn7gmjx5vicxlg4pqlzwqvhv";
  };

  patches = [ ./no-plymouth.patch ];

  preConfigure = "rm -R aclocal.m4; gettextize -f; autoreconf -vfi";

  buildInputs = [ pkgconfig libnih dbus.libs udev autoconf automake libtool gettext ];

  makeFlags = "initramfshookdir=$(out)/share/initramfs-tools/hooks upstart_jobs_initramfs_configdir=$(out)/share/initramfs-tools/event-driven/upstart-jobs";
  
  meta = {
    homepage = https://launchpad.net/ubuntu/+source/mountall;
    description = "Utility to mount all filesystems and emit Upstart events";
    platforms = stdenv.lib.platforms.linux;    
  };
}
