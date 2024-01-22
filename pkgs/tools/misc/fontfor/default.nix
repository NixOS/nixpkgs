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
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "7sDream";
    repo = "fontfor";
    rev = "v${version}";
    hash = "sha256-NeoEeiCsDHaMZn/Pl+fUl9499ru2nFGQRVBjlHwl0/8=";
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

  cargoHash = "sha256-9/ObVl4KNBodPbNpBJwiJF2mlXPOBL5eO0nEkvOHCK0=";

  meta = with lib; {
    description = "Find fonts which can show a specified character and preview them in browser";
    homepage = "https://github.com/7sDream/fontfor";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
    mainProgram = "fontfor";
  };
}
