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
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "eyeplum";
    repo = "cicero-tui";
    rev = "v${version}";
    sha256 = "sha256-FwjD+BdRc8y/g5MQLmBB/qkUj33cywbH2wjTp0y0s8A=";
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

  cargoSha256 = "sha256-JygEE7K8swbFvJ2aDXs+INhfoLuhy+LY7T8AUr4lgJY=";

  meta = with lib; {
    description = "Unicode tool with a terminal user interface";
    homepage = "https://github.com/eyeplum/cicero-tui";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
