{ lib, rustPlatform, fetchCrate, stdenv, Foundation }:

rustPlatform.buildRustPackage rec {
  pname = "vimv-rs";
  version = "2.0.0";

  src = fetchCrate {
    inherit version;
    crateName = "vimv";
    hash = "sha256-dc1jN9phrTfLwa6Dx1liXNu49V2qjpiuHqn4KQnPYWQ=";
  };

  cargoHash = "sha256-1Oa4R85w5FyC6rjoZe53bJIykSSkUv2X3LQvK4w+qs0=";

  buildInputs = lib.optionals stdenv.isDarwin [ Foundation ];

  meta = with lib; {
    description = "Command line utility for batch-renaming files";
    homepage = "https://www.dmulholl.com/dev/vimv.html";
    license = licenses.bsd0;
    mainProgram = "vimv";
    maintainers = with maintainers; [ zowoq ];
  };
}
