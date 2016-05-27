{ stdenv, fetchurl, fetchFromGitHub, cmake, pkgconfig
, python, pythonPackages, orc, libusb1, boost }:

# You need these udev rules to not have to run as root (copied from
# ${uhd}/share/uhd/utils/uhd-usrp.rules):
#
#   SUBSYSTEMS=="usb", ATTRS{idVendor}=="fffe", ATTRS{idProduct}=="0002", MODE:="0666"
#   SUBSYSTEMS=="usb", ATTRS{idVendor}=="2500", ATTRS{idProduct}=="0002", MODE:="0666"

stdenv.mkDerivation rec {
  name = "uhd-${version}";
  version = "3.9.3";

  # UHD seems to use three different version number styles: x.y.z, xxx_yyy_zzz
  # and xxx.yyy.zzz. Hrmpf...

  src = fetchFromGitHub {
    owner = "EttusResearch";
    repo = "uhd";
    rev = "release_003_009_003";
    sha256 = "0nbm8nrjd0l8jj1wq0kkgd8pifzysdyc7pvraq16m0dc01mr638h";
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
    homepage = http://ettus-apps.sourcerepo.com/redmine/ettus/projects/uhd/wiki;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bjornfor fpletz ];
  };
}
