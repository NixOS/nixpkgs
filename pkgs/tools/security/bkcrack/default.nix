{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "bkcrack";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "kimci86";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-VfPRX9lOPyen8CujiBtTCbD5e7xd9X2OQ1uZ6JWKwtY=";
  };

  nativeBuildInputs = [ cmake ];

  postInstall = ''
    mkdir -p $out/bin $out/share/licenses/bkcrack
    mv $out/bkcrack $out/bin/
    mv $out/license.txt $out/share/licenses/bkcrack
    rm -r $out/example $out/tools $out/readme.md
  '';

  meta = with lib; {
    description = "Crack legacy zip encryption with Biham and Kocher's known plaintext attack";
    homepage = "https://github.com/kimci86/bkcrack";
    license = licenses.zlib;
    platforms = platforms.unix;
    maintainers = with maintainers; [ erdnaxe ];
  };
}
