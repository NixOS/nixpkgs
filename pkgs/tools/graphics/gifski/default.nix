{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "gifski";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = "gifski";
    rev = version;
    sha256 = "0mr4ni75klmzfjivfv5xmcdw03y1gjvkz1d297gwh46zq1q7blf3";
  };

  cargoSha256 = "0wm139lik6w2hwg72j8hcphp0z89bbabfxjmfyqrih6akyzb0l01";

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "GIF encoder based on libimagequant (pngquant)";
    homepage = "https://gif.ski/";
    license = licenses.agpl3;
    maintainers = [ maintainers.marsam ];
  };
}
