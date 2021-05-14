{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, libiconv
}:

rustPlatform.buildRustPackage rec {
  pname = "code-minimap";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "wfxr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5YNY0MRlKKX6u32Id6J7bIPSHRi44TISoKqpAS9T8ow=";
  };

  cargoSha256 = "sha256-87aRZC4OE3UTVToHi5XDBxVqEH4oFeFR4REf69OBkIw=";

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  meta = with lib; {
    description = "A high performance code minimap render";
    homepage = "https://github.com/wfxr/code-minimap";
    license = with licenses; [ asl20 /* or */ mit ];
    maintainers = with maintainers; [ bsima ];
  };
}
