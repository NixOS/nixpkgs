{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "cfspeedtest";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "code-inflation";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ZbE8/mh9hb81cGz0Wxq3gTa9BueKfQApeq5z2DGUak0=";
  };

  cargoHash = "sha256-+cKQkogZc4iIIVMyHtbS44DNkCKD2cWkVN2o9m+WFbM=";

  meta = with lib; {
    description = "Unofficial CLI for speed.cloudflare.com";
    homepage = "https://github.com/code-inflation/cfspeedtest";
    license = with licenses; [ mit ];
    broken = stdenv.isDarwin;
    maintainers = with maintainers; [ colemickens ];
  };
}
