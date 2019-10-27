{ stdenv
, boost
, cmake
, fetchFromGitHub
, pkgconfig
, txt2tags
}:

stdenv.mkDerivation rec {
  pname = "thunderbolt";
  version = "0.9.3";
  src = fetchFromGitHub {
    owner = "01org";
    repo = "thunderbolt-software-user-space";
    rev = "v${version}";
    sha256 = "02w1bfm7xvq0dzkhwqiq0camkzz9kvciyhnsis61c8vzp39cwx0x";
  };

  nativeBuildInputs = [ cmake pkgconfig txt2tags ];
  buildInputs = [ boost ];

  cmakeFlags = [
    "-DUDEV_BIN_DIR=${placeholder "out"}/bin"
    "-DUDEV_RULES_DIR=${placeholder "out"}/etc/udev/rules.d"
  ];

  meta = {
    description = "Thunderbolt(TM) user-space components";
    license = stdenv.lib.licenses.bsd3;
    maintainers = [ stdenv.lib.maintainers.ryantrinkle ];
    homepage = https://01.org/thunderbolt-sw;
    platforms = stdenv.lib.platforms.linux;
  };
}
