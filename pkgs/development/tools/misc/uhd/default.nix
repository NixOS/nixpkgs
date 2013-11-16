{ stdenv, fetchurl, cmake, pkgconfig, python, cheetahTemplate, orc, libusb1, boost }:

# You need these udev rules to not have to run as root (copied from
# ${uhd}/share/uhd/utils/uhd-usrp.rules):
#
#   SUBSYSTEMS=="usb", ATTRS{idVendor}=="fffe", ATTRS{idProduct}=="0002", MODE:="0666"
#   SUBSYSTEMS=="usb", ATTRS{idVendor}=="2500", ATTRS{idProduct}=="0002", MODE:="0666"

stdenv.mkDerivation rec {
  name = "uhd-${version}";
  version = "3.5.4";

  # UHD seems to use three different version number styles: x.y.z, xxx_yyy_zzz
  # and xxx.yyy.zzz. Hrmpf...

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://github.com/EttusResearch/uhd/archive/release_003_005_004.tar.gz";
    sha256 = "1l11dv72r4ynfpw58aacq0kjylzw85yapv3kzc76lg6qgdb0pqrd";
  };

  cmakeFlags = "-DLIBUSB_INCLUDE_DIRS=${libusb1}/include/libusb-1.0";

  buildInputs = [ cmake pkgconfig python cheetahTemplate orc libusb1 boost ];

  # Build only the host software
  preConfigure = "cd host";

  # Firmware images are downloaded (pre-built)
  uhdImagesName = "uhd-images_003.005.004-release";
  uhdImagesSrc = fetchurl {
    url = "http://files.ettus.com/binaries/maint_images/archive/${uhdImagesName}.tar.gz";
    sha256 = "0lgy9076vshlaq7l4n3q1hka3q4xxzdz7mqh7kawg4dziq7j8nl6";
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
    maintainers = [ maintainers.bjornfor ];
  };
}
