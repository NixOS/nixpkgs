{ stdenv
, lib
, rustPlatform
, fetchFromGitHub
, DiskArbitration
, Foundation
}:

# unstable was chosen because of an added Cargo.lock
# revert to stable for the version after 0.9.0
let version = "unstable-2022-06-25";
in
rustPlatform.buildRustPackage {
  pname = "lnx";
  inherit version;
  src = fetchFromGitHub {
    owner = "lnx-search";
    repo = "lnx";
    rev = "2cb80f344c558bfe37f21ccfb83265bf351419d9";
    sha256 = "sha256-iwoZ6xRzEDArmhWYxIrbIXRTQjOizyTsXCvMdnUrs2g=";
  };
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "compose-0.1.0" = "sha256-zcniGI3wa+gI3jFTDqHcesX+6hAtNEbW81ABPUcFTXk=";
    };
  };
  buildInputs = lib.optionals stdenv.isDarwin [ DiskArbitration Foundation ];
  meta = with lib; {
    description = "Insanely fast, Feature-rich searching. lnx is the adaptable, typo tollerant deployment of the tantivy search engine. Standing on the shoulders of giants.";
    mainProgram = "lnx";
    homepage = "https://lnx.rs/";
    license = licenses.mit;
    maintainers = with maintainers; [ happysalada ];
    platforms = platforms.unix;
  };
}
