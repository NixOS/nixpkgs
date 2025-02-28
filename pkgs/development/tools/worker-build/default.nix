{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  Security,
}:

rustPlatform.buildRustPackage rec {
  pname = "worker-build";
  version = "0.0.18";

  src = fetchFromGitHub {
    owner = "cloudflare";
    repo = "workers-rs";
    rev = "v${version}";
    hash = "sha256-z6m14IbMzgycwnQpA28e4taokDSVpfZOKIRmFIwLjbg=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "postgres-protocol-0.6.5" = "sha256-xLyaappu7ebtKOoHY49dvjDEcuRg8IOv1bNH9RxSUcM=";
    };
  };

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ Security ];

  buildAndTestSubdir = "worker-build";

  # missing some module upstream to run the tests
  doCheck = false;

  meta = with lib; {
    description = "This is a tool to be used as a custom build command for a Cloudflare Workers `workers-rs` project";
    mainProgram = "worker-build";
    homepage = "https://github.com/cloudflare/workers-rs";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ happysalada ];
  };
}
