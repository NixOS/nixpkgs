{ stdenv, fetchFromGitHub, libusb1 }:

stdenv.mkDerivation rec {
  pname = "xow";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "medusalix";
    repo = "xow";
    rev = "v${version}";
    sha256 = "1xkwcx2gqip9v2h3zjmrn7sgcck3midl5alhsmr3zivgdipamynv";
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
  enableParallelBuilding = true;
  buildInputs = [ libusb1 ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/medusalix/xow";
    description = "Linux driver for the Xbox One wireless dongle";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.jansol ];
    platforms = platforms.linux;
  };
}
