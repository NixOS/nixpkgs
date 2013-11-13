{ stdenv, fetchgit, autoconf, automake, libtool, pkgconfig, libusb1 }:

# IMPORTANT: You need permissions to access the stlink usb devices. Here are
# example udev rules for stlink v1 and v2 so you don't need to have root
# permissions (copied from <stlink>/49-stlink*.rules):
#
# SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3744", MODE:="0666", SYMLINK+="stlinkv1_%n"
# SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", MODE:="0666", SYMLINK+="stlinkv2_%n"

stdenv.mkDerivation {
  name = "stlink-20130306";

  src = fetchgit {
    url = git://github.com/texane/stlink.git;
    rev = "5be889e3feb75fc7f594012c4855b4dc16940050";
  };

  buildInputs = [ autoconf automake libtool pkgconfig libusb1 ];
  preConfigure = "./autogen.sh";

  meta = with stdenv.lib; {
    description = "In-circuit debug and programming for ST-Link devices";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [maintainers.bjornfor];
  };
}
