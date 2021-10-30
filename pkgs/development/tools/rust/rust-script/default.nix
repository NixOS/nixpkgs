{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "rust-script";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "fornwall";
    repo = pname;
    rev = "v${version}";
    sha256 = "0jz8hlvl31c5h8whd6pnpmslw6w6alkxijd9lhgric1yypiym9x3";
  };

  cargoSha256 = "sha256-hg0QtxR1qm/x8G6HoN7xAyOwh9jiQvX2wWYjUR8YvMs=";

  # TODO: switch to `cargoCheckType = "false"` after #138822 is merged
  # tests only work in debug mode
  doCheck = false;

  meta = with lib; {
    description = "Run Rust files and expressions as scripts without any setup or compilation step";
    homepage = "https://rust-script.org";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
