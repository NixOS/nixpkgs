{ stdenv, fetchFromGitHub, qtbase, qtserialport, cmake }:

stdenv.mkDerivation rec {
  name = "cutecom-${version}";
  version = "0.50.0";
  src = fetchFromGitHub {
    owner = "neundorf";
    repo = "CuteCom";
    rev = "v${version}";
    sha256 = "0zjmbjrwwan9z5cphqjcq2h71cm4mw88j457lzdqb29cg4bdn3ag";
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
