{ lib, runCommand, fetchFromGitHub, fetchpatch
, rustPlatform, protobuf }:

let
  pname = "ankisyncd";
  version = "1.1.4";

  ankirev = "23.10.1";

  # anki-sync-server-rs expects anki sources in the 'anki' folder
  # of its own source tree, with a patch applied (mostly to make
  # some modules public): prepare our own 'src' manually
  src = runCommand "anki-sync-server-rs-src" {
    src = fetchFromGitHub {
      owner = "ankicommunity";
      repo = "anki-sync-server-rs";
      rev = version;
      hash = "sha256-iL4lJJAV4SrNeRX3s0ZpJ//lrwoKjLsltlX4d2wP6O0=";
    };
    patches = [
      (fetchpatch {
        name = "update for anki 23.10";
        #https://github.com/ankicommunity/anki-sync-server-rs/pull/76
        url = "https://github.com/ankicommunity/anki-sync-server-rs/commit/49e1488fec38c7a9549b8795b48a41e476a70479.patch";
        hash = "sha256-rn+ieUeOXd8WaoK5L0rCq9kYEY0BVID0ebSzxO3oRdQ=";
      })
    ];
  } ''
    cp -r "$src/." "$out"
    chmod -R +w "$out"
    cp -r "${ankiSrc}" "$out/anki"
    chmod -R +w "$out/anki"
    # temp: apply patch manually
    cd "$out"
    chmod +w anki_patch scripts
    patchPhase
    # temp: nixos' patchPhase does not rename files, replace * with ${ankirev}
    patch -d "$out/anki" -Np1 < "$out/anki_patch/"*"_anki_rslib.patch"
  '';

  # Note we do not use anki.src because the patch in ankisyncd's
  # sources expect a fixed version, so we pin it here.
  ankiSrc = fetchFromGitHub {
    owner = "ankitects";
    repo = "anki";
    rev = ankirev;
    hash = "sha256-leGdamjCehffv2ByL7JWdaUhxRA4ZEPRKxBphUVzfRw=";
    fetchSubmodules = true;
  };
in rustPlatform.buildRustPackage {
  inherit pname version src;

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "fsrs-0.1.0" = "sha256-bnLmJk2aaWBdgdsiasRrDG4NiTDMCDCXotCSoc0ldlk=";
      "percent-encoding-iri-2.2.0" = "sha256-kCBeS1PNExyJd4jWfDfctxq6iTdAq69jtxFQgCCQ8kQ=";
    };
  };

  nativeBuildInputs = [ protobuf ];

  # no rust-level test, skip useless build
  doCheck = false;

  meta = with lib; {
    description = "Standalone unofficial anki sync server";
    homepage = "https://github.com/ankicommunity/anki-sync-server-rs";
    license = with licenses; [ agpl3Only ];
    maintainers = with maintainers; [ martinetd ];
  };
}
