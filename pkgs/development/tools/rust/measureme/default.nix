{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "measureme";
  version = "11.0.1";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "measureme";
    rev = version;
    hash = "sha256-p8XSe/LyHrEHEuxe1uK0Iy1YoJFw/jWtFvTDMhJMmnM=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "analyzeme-9.2.0" = "sha256-YOZiux4ouWBToGFx0+fiqjcyrnSjwc+8Qfi2rLGT/18=";
      "decodeme-10.1.2" = "sha256-20PJnBS6TCnltRuCiYkHKJcivKGDDQUrBc70hAX89bc=";
    };
  };

  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  meta = with lib; {
    description = "Support crate for rustc's self-profiling feature";
    homepage = "https://github.com/rust-lang/measureme";
    license = licenses.asl20;
    maintainers = [ maintainers.t4ccer ];
  };
}
