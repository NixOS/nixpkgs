{ stdenv
, boost
, cmake
, fetchFromGitHub
, pkgconfig
, txt2tags
}:

stdenv.mkDerivation rec {
  name = "thunderbolt-${version}";
  version = "0.9.2";
  src = fetchFromGitHub {
    owner = "01org";
    repo = "thunderbolt-software-user-space";
    rev = "1ae06410180320a5d0e7408a8d1a6ae2aa443c23";
    sha256 = "03yk419gj0767lpk6zvla4jx3nx56zsg4x4adl4nd50xhn409rcc";
  };

  buildInputs = [
    boost
    cmake
    pkgconfig
    txt2tags
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE='Release'"
    "-DUDEV_BIN_DIR=$out/bin"
    "-DUDEV_RULES_DIR=$out/udev"
  ];

  meta = {
    description = "Thunderbolt(TM) user-space components";
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.ryantrinkle ];
    homepage = https://01.org/thunderbolt-sw;
    platforms = stdenv.lib.platforms.linux;
  };
}
