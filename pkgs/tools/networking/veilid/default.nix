{ lib
, stdenv
, AppKit
, Security
, fetchFromGitLab
, rustPlatform
, protobuf
, capnproto
, cmake
, testers
, veilid
}:

rustPlatform.buildRustPackage rec {
  pname = "veilid";
  version = "0.3.4";

  src = fetchFromGitLab {
    owner = "veilid";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-nEJxiox2aoQBV83vlpiBB4In59+lfHF6/a8HqDYcFT4=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ansi-parser-0.9.1" = "sha256-Vdjt8QDstrfxYfklZ5vYPGhVNG1BVh4cpKGwvvsHlS4=";
      "cursive-0.20.0" = "sha256-EGKO7JVN9hIqADKKC3mUHHOCSxMjPoXzYBZujzdgk3E=";
      "cursive_buffered_backend-0.6.1" = "sha256-+sTJnp570HupwaJxV2x+oKyLwNmqQ4HqOH2P1s9Hhw8=";
      "cursive_table_view-0.14.0" = "sha256-haos82qtobMsFCP3sNRu5u1mki4bsjrV+eqFxUGIHqk=";
    };
  };

  nativeBuildInputs = [
    capnproto
    cmake
    protobuf
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ AppKit Security ];

  cargoBuildFlags = [
    "--workspace"
  ];

  RUSTFLAGS = "--cfg tokio_unstable";

  doCheck = false;

  outputs = [ "out" "lib" "dev" ];

  postInstall = ''
    moveToOutput "lib" "$lib"
  '';

  passthru.tests = {
    veilid-version = testers.testVersion {
      package = veilid;
    };
  };

  meta = with lib; {
    description = "Open-source, peer-to-peer, mobile-first, networked application framework";
    mainProgram = "veilid-server";
    homepage = "https://veilid.com";
    license = licenses.mpl20;
    maintainers = with maintainers; [ bbigras qbit ];
  };
}
