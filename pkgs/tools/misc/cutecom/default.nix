{ mkDerivation, lib, fetchFromGitLab, qtbase, qtserialport, cmake }:

mkDerivation rec {
  pname = "cutecom";
  version = "0.51.0";

  src = fetchFromGitLab {
    owner = "cutecom";
    repo = "cutecom";
    rev = "v${version}";
    sha256 = "1zprabjs4z26hsb64fc3k790aiiqiz9d88j666xrzi4983m1bfv8";
  };

  preConfigure = ''
    substituteInPlace CMakeLists.txt \
      --replace "#find_package(Serialport REQUIRED)" "find_package(Qt5SerialPort REQUIRED)"
  '';

  buildInputs = [ qtbase qtserialport ];
  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "A graphical serial terminal";
    homepage = "https://gitlab.com/cutecom/cutecom/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ bennofs ];
    platforms = platforms.linux;
  };
}
