{ lib, rustPlatform, fetchFromGitLab, stdenv, darwin, nixosTests }:

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

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

  # tests failed on x86_64-darwin with SIGILL: illegal instruction
  doCheck = !(stdenv.isx86_64 && stdenv.isDarwin);

  passthru.tests = {
    inherit (nixosTests) matrix-conduit;
  };

  meta = with lib; {
    description = "A Matrix homeserver written in Rust";
    homepage = "https://conduit.rs/";
    license = licenses.asl20;
    maintainers = with maintainers; [ pstn piegames pimeys ];
    mainProgram = "conduit";
  };
}
