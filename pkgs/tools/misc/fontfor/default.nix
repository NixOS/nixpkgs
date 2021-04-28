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
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "7sDream";
    repo = "fontfor";
    rev = "v${version}";
    sha256 = "1b07hd41blwsnb91vh2ax9zigm4lh8n0i5man0cjmxhavvbfy12b";
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

  cargoSha256 = "194c4knjfb3pnpvw3zl1srwx3q1jp6z78vzln0q2mk5nf0a35yy0";

  meta = with lib; {
    description = "Find fonts which can show a specified character and preview them in browser";
    homepage = "https://github.com/7sDream/fontfor";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
