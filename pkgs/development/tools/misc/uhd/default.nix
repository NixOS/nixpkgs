{ stdenv, fetchurl, fetchFromGitHub, cmake, pkgconfig
, python, pythonPackages, orc, libusb1, boost }:

# You need these udev rules to not have to run as root (copied from
# ${uhd}/share/uhd/utils/uhd-usrp.rules):
#
#   SUBSYSTEMS=="usb", ATTRS{idVendor}=="fffe", ATTRS{idProduct}=="0002", MODE:="0666"
#   SUBSYSTEMS=="usb", ATTRS{idVendor}=="2500", ATTRS{idProduct}=="0002", MODE:="0666"

let
  uhdVer = "003_010_003_000";
  ImgVer = stdenv.lib.replaceStrings ["_"] ["."] uhdVer;

  # UHD seems to use three different version number styles: x.y.z, xxx_yyy_zzz
  # and xxx.yyy.zzz. Hrmpf...
  version = "3.10.3.0";

  # Firmware images are downloaded (pre-built) from:
  # http://files.ettus.com/binaries/images/
  uhdImagesSrc = fetchurl {
    url = "http://files.ettus.com/binaries/images/uhd-images_${ImgVer}-release.tar.gz";
    sha256 = "198awvw6zsh19ydgx5qry5yc6yahdval9wjrsqbyj51pnr6s5qvy";
  };

in stdenv.mkDerivation {
  name = "uhd-${version}";

  src = fetchFromGitHub {
    owner = "EttusResearch";
    repo = "uhd";
    rev = "release_${uhdVer}";
    sha256 = "1aj8qizbyz4shwawj3qlhl6pyyda59hhgm9cwrj7s5kfdi4vdlc3";
  };

  enableParallelBuilding = true;

  cmakeFlags = "-DLIBUSB_INCLUDE_DIRS=${libusb1.dev}/include/libusb-1.0";

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ python pythonPackages.pyramid_mako orc libusb1 boost ];

  # Build only the host software
  preConfigure = "cd host";

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
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ bjornfor fpletz ];
  };
}
