{ lib, rustPlatform, fetchFromGitHub, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "gifski";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = "gifski";
    rev = version;
    sha256 = "sha256-Cm/w0bwDMu5REsQpkwMBgnROxpI+nMQwC16dY/VdOFU=";
  };

  cargoSha256 = "sha256-fy8apB1UbpBAnp8mFnL7rNj/GSSUkNz/trqsVrAfFfI=";

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "GIF encoder based on libimagequant (pngquant)";
    homepage = "https://gif.ski/";
    license = licenses.agpl3;
    maintainers = [ maintainers.marsam ];
  };
}
