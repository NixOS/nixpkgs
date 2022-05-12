{ lib, stdenv, fetchFromGitHub, libusb1, xow_dongle-firmware }:

stdenv.mkDerivation rec {
  pname = "xow";
  version = "unstable-2022-04-24";

  src = fetchFromGitHub {
    owner = "medusalix";
    repo = "xow";
    rev = "d335d6024f8380f52767a7de67727d9b2f867871";
    sha256 = "0q5nr21p4dlx2a99hiivwz6qj9anrqqsdhiz6xi375yqkxis4251";
  };

  makeFlags = [
    "BUILD=RELEASE"
    "VERSION=${version}-${src.rev}"
    "BINDIR=${placeholder "out"}/bin"
    "UDEVDIR=${placeholder "out"}/lib/udev/rules.d"
    "MODLDIR=${placeholder "out"}/lib/modules-load.d"
    "MODPDIR=${placeholder "out"}/lib/modprobe.d"
    "SYSDDIR=${placeholder "out"}/lib/systemd/system"
    "FIRMWARE=${xow_dongle-firmware}/lib/firmware/xow_dongle.bin"
  ];

  enableParallelBuilding = true;
  buildInputs = [ libusb1 ];

  meta = with lib; {
    homepage = "https://github.com/medusalix/xow";
    description = "Linux driver for the Xbox One wireless dongle";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.jansol ];
    platforms = platforms.linux;
  };
}
