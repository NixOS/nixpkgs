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
  pname = "cicero-tui";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "eyeplum";
    repo = "cicero-tui";
    rev = "v${version}";
    sha256 = "sha256-j/AIuNE5WBNdUeXuKvvc4NqsVVk252tm4KR3w0e6bT8=";
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

  cargoSha256 = "sha256-yup6hluGF2x+0XDwK+JETyNu4TFNPmqD4Y0Wthxrbcc=";

  meta = with lib; {
    description = "Unicode tool with a terminal user interface";
    homepage = "https://github.com/eyeplum/cicero-tui";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
