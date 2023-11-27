{ lib, runCommand, fetchFromGitHub, rustPlatform, protobuf }:

let
  pname = "ankisyncd";
  version = "1.1.4";

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
  } ''
    cp -r "$src/." "$out"
    chmod +w "$out"
    cp -r "${ankiSrc}" "$out/anki"
    chmod -R +w "$out/anki"
    patch -d "$out/anki" -Np1 < "$src/anki_patch/d9d36078f17a2b4b8b44fcb802eb274911ebabe7_anki_rslib.patch"
  '';

  # Note we do not use anki.src because the patch in ankisyncd's
  # sources expect a fixed version, so we pin it here.
  ankiSrc = fetchFromGitHub {
    owner = "ankitects";
    repo = "anki";
    rev = "2.1.60";
    hash = "sha256-hNrf6asxF7r7QK2XO150yiRjyHAYKN8OFCFYX0SAiwA=";
    fetchSubmodules = true;
  };
in rustPlatform.buildRustPackage {
  inherit pname version src;

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "csv-1.1.6" = "sha256-w728ffOVkI+IfK6FbmkGhr0CjuyqgJnPB1kutMJIUYg=";
    };
  };

  nativeBuildInputs = [ protobuf ];

  meta = with lib; {
    description = "Standalone unofficial anki sync server";
    homepage = "https://github.com/ankicommunity/anki-sync-server-rs";
    license = with licenses; [ agpl3Only ];
    maintainers = with maintainers; [ martinetd ];
    mainProgram = "ankisyncd";
  };
}
