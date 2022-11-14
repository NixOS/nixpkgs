{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-auditable";
  version = "0.5.4";

  src = fetchFromGitHub {
    owner = "rust-secure-code";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-udn/Z+raf/fkJ5M/FSH9Au+J9ASu0rz6ZJSl8P+jLT4=";
  };

  cargoSha256 = "sha256-k3wWdlLYGZZ44IHatXWq8TK2xCia3YES2jX286QkNH0=";

  meta = with lib; {
    description = "A tool to make production Rust binaries auditable";
    homepage = "https://github.com/rust-secure-code/cargo-auditable";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
