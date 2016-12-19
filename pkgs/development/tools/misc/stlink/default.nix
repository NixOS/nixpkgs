{ stdenv, fetchurl, autoconf, automake, libtool, pkgconfig, libusb1 }:

# IMPORTANT: You need permissions to access the stlink usb devices. Here are
# example udev rules for stlink v1 and v2 so you don't need to have root
# permissions (copied from <stlink>/49-stlink*.rules):
#
# SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3744", MODE:="0666", SYMLINK+="stlinkv1_%n"
# SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", MODE:="0666", SYMLINK+="stlinkv2_%n"

let
  version = "1.1.0";
in
stdenv.mkDerivation {
  name = "stlink-${version}";

  src = fetchurl {
    url = "https://github.com/texane/stlink/archive/${version}.tar.gz";
    sha256 = "0b38a32ids9dpnz5h892l279fz8y1zzqk1qsnyhl1nm03p7xzi1s";
  };

  buildInputs = [ autoconf automake libtool pkgconfig libusb1 ];
  preConfigure = "./autogen.sh";

  meta = with stdenv.lib; {
    description = "In-circuit debug and programming for ST-Link devices";
    license = licenses.bsd3;
    platforms = platforms.linux;
    maintainers = [ maintainers.bjornfor ];
  };
}
