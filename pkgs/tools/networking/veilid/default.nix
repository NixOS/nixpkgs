{ lib
, stdenv
, AppKit
, Security
, fetchFromGitLab
, rustPlatform
, protobuf
, capnproto
}:

rustPlatform.buildRustPackage rec {
  pname = "veilid";
  version = "0.3.0";

  src = fetchFromGitLab {
    owner = "veilid";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Hwumwc6XHHCyjmOqIhhUzGEhah5ASrBZ8EYwYVag0Fo=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ansi-parser-0.9.0" = "sha256-3qTJ4J3QE73ScDShnTFD4WPiZaDaiss0wqXmeRQEIt0=";
      "cursive-0.20.0" = "sha256-EGKO7JVN9hIqADKKC3mUHHOCSxMjPoXzYBZujzdgk3E=";
      "cursive_buffered_backend-0.6.1" = "sha256-+sTJnp570HupwaJxV2x+oKyLwNmqQ4HqOH2P1s9Hhw8=";
      "cursive_table_view-0.14.0" = "sha256-haos82qtobMsFCP3sNRu5u1mki4bsjrV+eqFxUGIHqk=";
    };
  };

  nativeBuildInputs = [
    capnproto
    protobuf
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ AppKit Security ];

  cargoBuildFlags = [
    "--workspace"
  ];

  doCheck = false;

  outputs = [ "out" "lib" "dev" ];

  postInstall = ''
    moveToOutput "lib" "$lib"
  '';

  meta = with lib; {
    description = "An open-source, peer-to-peer, mobile-first, networked application framework";
    homepage = "https://veilid.com";
    license = licenses.mpl20;
    maintainers = with maintainers; [ bbigras qbit ];
  };
}
