{ stdenv, lib, fetchFromGitLab, rustPlatform, pkg-config, rocksdb }:

rustPlatform.buildRustPackage rec {
  pname = "matrix-conduit";
  version = "0.4.0";

  src = fetchFromGitLab {
    owner = "famedly";
    repo = "conduit";
    rev = "v${version}";
    sha256 = "sha256-QTXDIvGz12ZxsWmPiMiJ8mBUWoJ2wnaeTZdXcwBh35o=";
  };

  cargoSha256 = "sha256-vE44I8lQ5VAfZB4WKLRv/xudoZJaFJGTT/UuumTePBU=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    pkg-config
    rocksdb
  ];

  cargoBuildFlags = "--bin conduit";

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A Matrix homeserver written in Rust";
    homepage = "https://conduit.rs/";
    license = licenses.asl20;
    maintainers = with maintainers; [ pstn piegames pimeys ];
  };
}
