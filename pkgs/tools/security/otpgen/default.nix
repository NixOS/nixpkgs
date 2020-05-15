{ 
  pkgs ? import <nixpkgs> {}
  , lib ? pkgs.lib
  , stdenv ? pkgs.stdenv
  , makeWrapper ? pkgs.makeWrapper
  , fetchFromGitHub ? pkgs.fetchFromGitHub
  , fakeSha256 ? pkgs.lib.fakeSha256
  , cmake ? pkgs.cmake
  , pkg-config ? pkgs.pkg-config
  , cryptopp ? pkgs.cryptopp
  , qtbase ? pkgs.qt5.qtbase
}:

stdenv.mkDerivation {

  name = "OTPGen";

  meta = {
    description = "MULTI-PURPOSE OTP TOKEN GENERATOR WRITTEN IN C++ AND QT WITH ENCRYPTION AND SYSTEM TRAY ICON. SUPPORTS TOTP, HOTP, AUTHY AND STEAM AND CUSTOM DIGIT LENGTHS AND PERIODS.";
    license = lib.licenses.mit;
    homepage = "https://github.com/magiruuvelvet/OTPGen";
    maintainers = [ "Scott Hamilton <sgn'dot'hamilton'at'protonmail'dot'com>" ];
    priority = "10";
    timeout = 3600;
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
