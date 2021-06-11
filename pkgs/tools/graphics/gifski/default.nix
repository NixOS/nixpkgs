{ lib, rustPlatform, fetchFromGitHub, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "gifski";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = "gifski";
    rev = version;
    sha256 = "034csv43vc0q2ycwjfskv1zx08c40ykf1m22fh9wvms0860k2ysn";
  };

  cargoSha256 = "0jgwf30gqwwpaf2g5zbsglcmsa00vixrnlizvcd41afi1wkjgiyd";

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "GIF encoder based on libimagequant (pngquant)";
    homepage = "https://gif.ski/";
    license = licenses.agpl3;
    maintainers = [ maintainers.marsam ];
  };
}
