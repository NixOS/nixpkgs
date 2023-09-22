{ lib
, fetchFromGitHub
, rustPlatform
, git
, protobuf
}:

let
  ankiSrc = fetchFromGitHub {
    owner = "ankitects";
    repo = "anki";
     # when updating, check the ANKI_COMMIT variable in
     # https://github.com/ankicommunity/anki-sync-server-rs/blob/master/scripts/clone_patch_anki
    rev = "d9d36078f17a2b4b8b44fcb802eb274911ebabe7";
    hash = "sha256-uQPu3mgYzS2sTx4kwxu6eZw83rVLaHA5mMs1JZtoTpQ=";
  };
  in
  rustPlatform.buildRustPackage rec {
  pname = "ankisyncd-rs";
  version = "1.1.4";
  src = fetchFromGitHub {
    owner = "ankicommunity";
    repo = "anki-sync-server-rs";
    rev = version;
    hash = "sha256-/sM2/ccIbOXJtjnBipfHgfnVTDNNI+zP/LT+CdSvQT8=";
  };
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "csv-1.1.6"= "sha256-w728ffOVkI+IfK6FbmkGhr0CjuyqgJnPB1kutMJIUYg=";
    };
  };
  nativeBuildInputs = [ git protobuf ];
  postPatch = ''
    cp -r ${ankiSrc} anki
    chmod -R +w anki
    cd anki
    git apply ../anki_patch/*
    cd ..
  '';
}
