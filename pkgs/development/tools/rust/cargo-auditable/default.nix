{ lib, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-auditable";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "rust-secure-code";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-m3M2uTQIOLK14VJ5mQfHw72hgAyJBVO2OAzDglByLmo=";
  };

  # not using fetchCrate since it has two binary crates
  cargoLock.lockFile = ./Cargo.lock;

  postPatch = ''
    cp ${./Cargo.lock} Cargo.lock
  '';

  meta = with lib; {
    description = "A tool to make production Rust binaries auditable";
    homepage = "https://github.com/rust-secure-code/cargo-auditable";
    changelog = "https://github.com/rust-secure-code/cargo-auditable/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit /* or */ asl20 ];
    maintainers = with maintainers; [ figsoda ];
  };
}
