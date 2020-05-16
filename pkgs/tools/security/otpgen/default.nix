{ 
  pkgs
  , lib
  , stdenv
  , makeWrapper
  , fetchFromGitHub
  , fakeSha256
  , cmake
  , pkg-config
  , cryptopp
  , qtbase
}:

stdenv.mkDerivation {

  name = "OTPGen";

  meta = {
    description = "MULTI-PURPOSE OTP TOKEN GENERATOR WRITTEN IN C++ AND QT WITH ENCRYPTION AND SYSTEM TRAY ICON. SUPPORTS TOTP, HOTP, AUTHY AND STEAM AND CUSTOM DIGIT LENGTHS AND PERIODS.";
    license = lib.licenses.mit;
    homepage = "https://github.com/magiruuvelvet/OTPGen";
    maintainers = with lib.maintainers; [ shamilton ];
    platforms = stdenv.lib.platforms.linux;
  };

  nativeBuildInputs = [ cmake  ];
  buildInputs = [ cryptopp qtbase ];
  depsBuildBuild = [ pkg-config  ];

  src = fetchFromGitHub {
    owner = "magiruuvelvet";
    repo = "OTPGen";
    rev = "97c7aabfe618c174da5b2ab3bf62e828e3d1798f";
    sha256 = "sha256:0nlhjkmr5a8ivpbk1hys6zkrbrbs1kghsimzfw9z59ymnk9k10ll";
  };

  cmakeFlags = [ "-DBUILD_MIGRATION_TOOL=ON" ];

  patches = [ ./core-cmake-cxx.patch ./migration-cmakelists.patch ./cmakelists.patch ];
}
