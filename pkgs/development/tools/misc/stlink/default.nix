{ stdenv, fetchurl, cmake, libusb1 }:

# IMPORTANT: You need permissions to access the stlink usb devices. 
# Add services.udev.pkgs = [ pkgs.stlink ] to your configuration.nix

let
  version = "1.3.0";
in
stdenv.mkDerivation {
  name = "stlink-${version}";

  src = fetchurl {
    url = "https://github.com/texane/stlink/archive/${version}.tar.gz";
    sha256 = "3e8cba21744d2c38a0557f6835a05189e1b98202931bb0183d22efc462c893dd";
  };

  buildInputs = [ cmake libusb1 ];
  patchPhase = ''
    sed -i 's@/etc/udev/rules.d@$ENV{out}/etc/udev/rules.d@' CMakeLists.txt
    sed -i 's@/etc/modprobe.d@$ENV{out}/etc/modprobe.d@' CMakeLists.txt
  '';
  preInstall = ''
    mkdir -p $out/etc/udev/rules.d
    mkdir -p $out/etc/modprobe.d
  '';

  meta = with stdenv.lib; {
    description = "In-circuit debug and programming for ST-Link devices";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor maintainers.rongcuid ];
  };
}
