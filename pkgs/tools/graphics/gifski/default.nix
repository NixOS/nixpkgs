{ lib, stdenv, rustPlatform, fetchFromGitHub, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "gifski";
  version = "1.2.6";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = "gifski";
    rev = version;
    sha256 = "sha256-pnaNBjMKWfnCHG4MTLS2tJ2lrKxH6tcnvbOFZSDtPJY=";
  };

  cargoSha256 = "sha256-M5LEoEaWKT6nfQsnuqfyRBtDILewAxzMs7d6DvhkvFg=";

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "GIF encoder based on libimagequant (pngquant)";
    homepage = "https://gif.ski/";
    license = licenses.agpl3;
    maintainers = [ maintainers.marsam ];
  };
}
