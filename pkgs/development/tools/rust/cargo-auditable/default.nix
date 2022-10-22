{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-auditable";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "rust-secure-code";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4CHuthi7GXZKHenOE2Bk+Ps1AJlPkhvMIGHmV9Z00hA=";
  };

  cargoSha256 = "sha256-puq8BgYuynFZCepYZdQ9ggDYJlFDks7s/l3UxM9F7ag=";

  meta = with lib; {
    description = "A tool to make production Rust binaries auditable";
    homepage = "https://github.com/rust-secure-code/cargo-auditable";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
