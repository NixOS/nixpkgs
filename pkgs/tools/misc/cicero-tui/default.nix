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
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "eyeplum";
    repo = "cicero-tui";
    rev = "v${version}";
    sha256 = "sha256-TNNPTKLO5qjSeCxWb7bB4yV1J4Seu+tBKNs0Oav/pPE=";
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

  cargoSha256 = "sha256-kzU+i5DLmZULdJPURz10URE5sMUG6eQg0pCoEiyfgco=";

  meta = with lib; {
    description = "Unicode tool with a terminal user interface";
    homepage = "https://github.com/eyeplum/cicero-tui";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
