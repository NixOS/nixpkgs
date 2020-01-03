{ stdenv, fetchFromGitHub, cmake, libusb1 }:

# IMPORTANT: You need permissions to access the stlink usb devices. 
# Add services.udev.pkgs = [ pkgs.stlink ] to your configuration.nix

let
  version = "1.5.1";
in
stdenv.mkDerivation {
  pname = "stlink";
  inherit version;

  src = fetchFromGitHub {
    owner = "texane";
    repo = "stlink";
    rev = "v1.5.1";
    sha256 = "1d5gxiqpsm8fc105cxlp27af9fk339fap5h6nay21x5a7n61jgyc";
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
