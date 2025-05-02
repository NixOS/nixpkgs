{ lib
, rustPlatform
, fetchFromGitHub
, cmake
, pkg-config
, expat
, fontconfig
, freetype
}:

rustPlatform.buildRustPackage rec {
  pname = "fontfor";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "7sDream";
    repo = "fontfor";
    rev = "v${version}";
    sha256 = "sha256-/UoZ+5X6Csoyqc+RSP0Hree7NtCDs7BjsqcpALxAazc=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    expat
    fontconfig
    freetype
  ];

  cargoHash = "sha256-j1Qf0IKlAUEyiGAUoF7IlEbPIv2pGkn+YMCoFdF9oUE=";

  meta = with lib; {
    description = "Find fonts which can show a specified character and preview them in browser";
    homepage = "https://github.com/7sDream/fontfor";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
    mainProgram = "fontfor";
  };
}
