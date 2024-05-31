{ lib, stdenv, fetchFromGitHub, rustPlatform, pkg-config, openssl, Security }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-whatfeatures";
  version = "0.9.12";

  src = fetchFromGitHub {
    owner = "museun";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-62eEHxX+Gsz+Bif1ev0nTRituRkfqlGYZfa9cFkO26M=";
  };

  cargoHash = "sha256-bk/mbQu4lzhA9ct7cws70MYuj8oNEBgC+0EjHlaN1lc=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optionals stdenv.isDarwin [ Security ];

  meta = with lib; {
    description = "A simple cargo plugin to get a list of features for a specific crate";
    mainProgram = "cargo-whatfeatures";
    homepage = "https://github.com/museun/cargo-whatfeatures";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ ivan-babrou matthiasbeyer ];
  };
}
