{ stdenv, rustPlatform, fetchFromGitHub, pkgconfig }:

rustPlatform.buildRustPackage rec {
  pname = "gifski";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = "gifski";
    rev = version;
    sha256 = "0dl5725imb2a2s0fskdqlnh2207ryyi2v5gz37cr5mf6khz898p2";
  };

  cargoSha256 = "0wngsd0pmmxlwzxmyp8pvphh1ijs5s9k1mkkv688xpc4b8w0z10j";

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    description = "GIF encoder based on libimagequant (pngquant)";
    homepage = https://gif.ski/;
    license = licenses.agpl3;
    maintainers = [ maintainers.marsam ];
  };
}
