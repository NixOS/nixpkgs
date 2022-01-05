{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "code-minimap";
  version = "0.6.2";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-nUEmlKqCskPEQCOS2NC6jF4yVDarJeb3p+BKZq/2qvw=";
  };

  cargoSha256 = "sha256-yjjoQYYWK9/9fOP5ICnhpuF/07SyCszB9GCDr0GJ0v0=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description = "A high performance code minimap render";
    homepage = "https://github.com/wfxr/code-minimap";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ bsima ];
  };
}
