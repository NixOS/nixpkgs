{ stdenv, fetchFromGitHub, qtbase, qtserialport, cmake }:

stdenv.mkDerivation rec {
  name = "cutecom-${version}";
  version = "0.45.0";
  src = fetchFromGitHub {
    owner = "neundorf";
    repo = "CuteCom";
    rev = "v${version}";
    sha256 = "07h1r7bcz86fvcvxq6g5zyh7fsginx27jbp81a7hjhhhn6v0dsmh";
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
    platforms = stdenv.lib.platforms.linux;
  };
}
