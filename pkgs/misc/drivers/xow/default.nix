{ stdenv, cabextract, fetchurl, fetchFromGitHub, libusb1 }:

stdenv.mkDerivation rec {
  pname = "xow";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "medusalix";
    repo = "xow";
    rev = "v${version}";
    sha256 = "071r2kx44k1sc49cad3i607xg618mf34ki1ykr5lnfx9y6qyz075";
  };

  firmware = fetchurl {
    url = "http://download.windowsupdate.com/c/msdownload/update/driver/drvs/2017/07/1cd6a87c-623f-4407-a52d-c31be49e925c_e19f60808bdcbfbd3c3df6be3e71ffc52e43261e.cab";
    sha256 = "013g1zngxffavqrk5jy934q3bdhsv6z05ilfixdn8dj0zy26lwv5";
  };

  makeFlags = [
    "BUILD=RELEASE"
    "VERSION=${version}"
    "BINDIR=${placeholder ''out''}/bin"
    "UDEVDIR=${placeholder ''out''}/lib/udev/rules.d"
    "MODLDIR=${placeholder ''out''}/lib/modules-load.d"
    "MODPDIR=${placeholder ''out''}/lib/modprobe.d"
    "SYSDDIR=${placeholder ''out''}/lib/systemd/system"
  ];

  postUnpack = ''
    cabextract -F FW_ACC_00U.bin ${firmware}
    mv FW_ACC_00U.bin source/firmware.bin
  '';

  enableParallelBuilding = true;
  nativeBuildInputs = [ cabextract ];
  buildInputs = [ libusb1 ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/medusalix/xow";
    description = "Linux driver for the Xbox One wireless dongle";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.jansol ];
    platforms = platforms.linux;
  };
}
