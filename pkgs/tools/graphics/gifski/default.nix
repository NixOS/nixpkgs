{ stdenv, lib, rustPlatform, fetchFromGitHub, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "gifski";
  version = "1.6.4";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = "gifski";
    rev = version;
    sha256 = "sha256-TD6MSZfvJ8fLJxvDh4fc4Dij5t4WSH2/i9Jz7eBmlME=";
  };

  cargoSha256 = "sha256-kG0svhytDzm2dc//8WTFm1sI3WS0Ny9yhYTSMoXnt8I=";

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "GIF encoder based on libimagequant (pngquant)";
    homepage = "https://gif.ski/";
    license = licenses.agpl3;
    maintainers = [ maintainers.marsam ];
  };
}
