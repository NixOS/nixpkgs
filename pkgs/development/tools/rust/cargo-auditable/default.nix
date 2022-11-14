{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-auditable";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "rust-secure-code";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-bRx+a6vzjiS2dglVkTyUm8OASM2Qq05S7LuVkHaIYMU=";
  };

  cargoSha256 = "sha256-QZi45U+MV8h4AMcN3QLIfAn/gHzoBWuOsC7gDSBY2jI=";

  meta = with lib; {
    description = "A tool to make production Rust binaries auditable";
    homepage = "https://github.com/rust-secure-code/cargo-auditable";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
