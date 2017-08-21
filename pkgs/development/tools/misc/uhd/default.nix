{ stdenv, fetchurl, fetchFromGitHub, cmake, pkgconfig
, python, pythonPackages, orc, libusb1, boost }:

# You need these udev rules to not have to run as root (copied from
# ${uhd}/share/uhd/utils/uhd-usrp.rules):
#
#   SUBSYSTEMS=="usb", ATTRS{idVendor}=="fffe", ATTRS{idProduct}=="0002", MODE:="0666"
#   SUBSYSTEMS=="usb", ATTRS{idVendor}=="2500", ATTRS{idProduct}=="0002", MODE:="0666"

stdenv.mkDerivation rec {
  name = "uhd-${version}";
  version = "3.10.1.1";

  # UHD seems to use three different version number styles: x.y.z, xxx_yyy_zzz
  # and xxx.yyy.zzz. Hrmpf...

  src = fetchFromGitHub {
    owner = "EttusResearch";
    repo = "uhd";
    rev = "release_003_010_001_001";
    sha256 = "009pynjfpwbf3vfyg4w5yhcn4xb93afagqb3p5svjxzswh90j1d2";
  };

  enableParallelBuilding = true;

  cmakeFlags = "-DLIBUSB_INCLUDE_DIRS=${libusb1.dev}/include/libusb-1.0";

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ python pythonPackages.pyramid_mako orc libusb1 boost ];

  # Build only the host software
  preConfigure = "cd host";

  # Firmware images are downloaded (pre-built)
  uhdImagesName = "uhd-images_003.007.003-release";
  uhdImagesSrc = fetchurl {
    url = "http://files.ettus.com/binaries/maint_images/archive/${uhdImagesName}.tar.gz";
    sha256 = "1pv5c5902041494z0jfw623ca29pvylrw5klybbhklvn5wwlr6cv";
  };

  postPhases = [ "installFirmware" ];

  installFirmware = ''
    tar --strip-components=1 -xvf "${uhdImagesSrc}" -C "$out"
  '';

  meta = with stdenv.lib; {
    description = "USRP Hardware Driver (for Software Defined Radio)";
    longDescription = ''
      The USRP Hardware Driver (UHD) software is the hardware driver for all
      USRP (Universal Software Radio Peripheral) devices.

      USRP devices are designed and sold by Ettus Research, LLC and its parent
      company, National Instruments.
    '';
    homepage = https://uhd.ettus.com/;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor fpletz ];
  };
}
