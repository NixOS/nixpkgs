{ lib, rustPlatform, fetchFromGitHub, pkg-config }:

rustPlatform.buildRustPackage rec {
  pname = "gifski";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = "gifski";
    rev = version;
    sha256 = "sha256-x2p+6m1pwXhmI9JvGUgLhxrGwpJa/e2wb5wOFdKQ2xg=";
  };

  cargoSha256 = "sha256-8t7VhPby56UX2LlD2xcJKkWamuJxN9LiVEQPEa78EQQ=";

  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "GIF encoder based on libimagequant (pngquant)";
    homepage = "https://gif.ski/";
    license = licenses.agpl3;
    maintainers = [ maintainers.marsam ];
  };
}
