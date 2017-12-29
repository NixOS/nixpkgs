{ stdenv, fetchFromGitHub, qtbase, qtserialport, cmake }:

stdenv.mkDerivation rec {
  name = "cutecom-${version}";
  version = "0.40.0";
  src = fetchFromGitHub {
    owner = "neundorf";
    repo = "CuteCom";
    rev = "v${version}";
    sha256 = "1bn6vndqlvn73riq6p0nanmcl35ja9gsil5hvfpf509r7i8gx4ds";
  };

  preConfigure = ''
    substituteInPlace CMakeLists.txt --replace "#find_package(Serialport REQUIRED)" "find_package(Qt5SerialPort REQUIRED)"
  '';
  buildInputs = [qtbase qtserialport cmake];

  meta = {
    description = "A graphical serial terminal";
    homepage = http://cutecom.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.bennofs ];
    platforms = stdenv.lib.platforms.unix;
  };
}
