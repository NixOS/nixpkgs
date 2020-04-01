{ stdenv, fetchFromGitHub, cmake, libusb1 }:

# IMPORTANT: You need permissions to access the stlink usb devices. 
# Add services.udev.pkgs = [ pkgs.stlink ] to your configuration.nix

stdenv.mkDerivation rec {
  pname = "stlink";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "texane";
    repo = "stlink";
    rev = "v${version}";
    sha256 = "1mlkrxjxg538335g59hjb0zc739dx4mhbspb26z5gz3lf7d4xv6x";
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
