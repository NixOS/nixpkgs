{ lib, stdenv, cabextract, fetchurl, fetchFromGitHub, libusb1 }:

stdenv.mkDerivation rec {
  pname = "xow";
  version = "unstable-2022-04-24";

  src = fetchFromGitHub {
    owner = "medusalix";
    repo = "xow";
    rev = "d335d6024f8380f52767a7de67727d9b2f867871";
    sha256 = "0q5nr21p4dlx2a99hiivwz6qj9anrqqsdhiz6xi375yqkxis4251";
  };

  firmware = fetchurl {
    url = "http://download.windowsupdate.com/c/msdownload/update/driver/drvs/2017/07/1cd6a87c-623f-4407-a52d-c31be49e925c_e19f60808bdcbfbd3c3df6be3e71ffc52e43261e.cab";
    sha256 = "013g1zngxffavqrk5jy934q3bdhsv6z05ilfixdn8dj0zy26lwv5";
  };

  makeFlags = [
    "BUILD=RELEASE"
    "VERSION=${version}-${src.rev}"
    "BINDIR=${placeholder "out"}/bin"
    "UDEVDIR=${placeholder "out"}/lib/udev/rules.d"
    "MODLDIR=${placeholder "out"}/lib/modules-load.d"
    "MODPDIR=${placeholder "out"}/lib/modprobe.d"
    "SYSDDIR=${placeholder "out"}/lib/systemd/system"
  ];

  postUnpack = ''
    cabextract -F FW_ACC_00U.bin ${firmware}
    mv FW_ACC_00U.bin source/firmware.bin
  '';

  enableParallelBuilding = true;
  nativeBuildInputs = [ cabextract ];
  buildInputs = [ libusb1 ];

  meta = with lib; {
    homepage = "https://github.com/medusalix/xow";
    description = "Linux driver for the Xbox One wireless dongle";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.jansol ];
    platforms = platforms.linux;
  };
}
