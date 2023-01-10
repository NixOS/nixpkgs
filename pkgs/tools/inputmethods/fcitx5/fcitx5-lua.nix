{ lib
, stdenv
, fetchFromGitHub
, cmake
, extra-cmake-modules
, fcitx5
, lua
, gettext
}:
stdenv.mkDerivation rec {
  pname = "fcitx5-lua";
  version = "5.0.10";

  src = fetchFromGitHub {
    owner = "fcitx";
    repo = pname;
    rev = version;
    sha256 = "sha256-0ESgQv8kyc+zv/tDZtBZ+QhFFswD80ApwswFlJs8tOU=";
  };

  nativeBuildInputs = [ cmake extra-cmake-modules ];

  buildInputs = [ fcitx5 lua gettext ];

  passthru = {
    extraLdLibraries = [ lua ];
  };

  meta = with lib; {
    description = "Lua support for Fcitx 5";
    homepage = "https://github.com/fcitx/fcitx5-lua";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ poscat ];
    platforms = platforms.linux;
  };
}
