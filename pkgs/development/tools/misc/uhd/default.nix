{ stdenv, fetchurl, fetchFromGitHub, cmake, pkgconfig
, python, pythonPackages, orc, libusb1, boost }:

# You need these udev rules to not have to run as root (copied from
# ${uhd}/share/uhd/utils/uhd-usrp.rules):
#
#   SUBSYSTEMS=="usb", ATTRS{idVendor}=="fffe", ATTRS{idProduct}=="0002", MODE:="0666"
#   SUBSYSTEMS=="usb", ATTRS{idVendor}=="2500", ATTRS{idProduct}=="0002", MODE:="0666"

let
  uhdVer = "v" + version;
  ImgVer = "uhd-images_3.11.0.git-227-g9277fc58.tar.xz";

  # UHD seems to use three different version number styles: x.y.z, xxx_yyy_zzz
  # and xxx.yyy.zzz. Hrmpf... style keeps changing
  version = "3.11.0.0";

  # Firmware images are downloaded (pre-built) from:
  # http://files.ettus.com/binaries/images/
  uhdImagesSrc = fetchurl {
    url = "http://files.ettus.com/binaries/images/${ImgVer}";
    sha256 = "1z8isnlxc5h0168jjpdvdv7rkd55x4dkfh14m8pc501zsf8azd6z";
  };

in stdenv.mkDerivation {
  name = "uhd-${version}";

  src = fetchFromGitHub {
    owner = "EttusResearch";
    repo = "uhd";
    rev = "${uhdVer}";
    sha256 = "1ilx1a8k5zygfq7acm9yk2fi368b1a1l7ll21kmmxjv6ifz8ds5q";
  };

  enableParallelBuilding = true;

  # ABI differences GCC 7.1
  # /nix/store/wd6r25miqbk9ia53pp669gn4wrg9n9cj-gcc-7.3.0/include/c++/7.3.0/bits/vector.tcc:394:7: note: parameter passing for argument of type 'std::vector<uhd::range_t>::iterator {aka __gnu_cxx::__normal_iterator<uhd::range_t*, std::vector<uhd::range_t> >}' changed in GCC 7.1

  cmakeFlags = [ "-DLIBUSB_INCLUDE_DIRS=${libusb1.dev}/include/libusb-1.0"] ++
               [ (stdenv.lib.optionalString stdenv.isAarch32 "-DCMAKE_CXX_FLAGS=-Wno-psabi") ];

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ python pythonPackages.pyramid_mako orc libusb1 boost ];

  # Build only the host software
  preConfigure = "cd host";
  patches = if stdenv.isAarch32 then ./neon.patch else null;

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
    maintainers = with maintainers; [ bjornfor fpletz tomberek ];
  };
}
