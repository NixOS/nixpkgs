{ lib, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "measureme";
  version = "10.1.1";

  src = fetchFromGitHub {
    owner = "rust-lang";
    repo = "measureme";
    rev = version;
    hash = "sha256-RCh6fTa4d+/Fj5ID5Su3pCZj/O+FhITzfKixXu9G550=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "analyzeme-9.2.0" = "sha256-YOZiux4ouWBToGFx0+fiqjcyrnSjwc+8Qfi2rLGT/18=";
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
