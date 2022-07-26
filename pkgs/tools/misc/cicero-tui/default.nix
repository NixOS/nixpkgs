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
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "eyeplum";
    repo = "cicero-tui";
    rev = "v${version}";
    sha256 = "sha256-5/yH5ZK/JgMsRUcJ0qQEShEqxrtKJa+P6pcHAn5Jx0c=";
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

  cargoSha256 = "sha256-AraisWGTPEj+tHcLonEwfevBu+mMTPkq3O9zNYgI9X8=";

  meta = with lib; {
    description = "Unicode tool with a terminal user interface";
    homepage = "https://github.com/eyeplum/cicero-tui";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
