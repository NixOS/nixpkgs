{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "wasm-tools";
<<<<<<< HEAD
  version = "1.0.40";
=======
  version = "1.0.30";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = pname;
    rev = "${pname}-${version}";
<<<<<<< HEAD
    hash = "sha256-ZDQPIEDroi+YgEtQ9IsVvFSErfeyDf4KFuybEbGu91E=";
    fetchSubmodules = true;
  };

  cargoHash = "sha256-Nynn7pxQyqfMAMGmp3eZFg7y5nj7UPyK6FLbVbN07AA=";
  cargoBuildFlags = [ "--package" "wasm-tools" ];
=======
    hash = "sha256-Sd4oYHywXejLPDbNmQ73bWGw48QNQ8M+2l3CjC6D6Iw=";
    fetchSubmodules = true;
  };

  cargoLock.lockFile = ./Cargo.lock;
  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  cargoBuildFlags = [ "--package" "wasm-tools" ];

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  cargoTestFlags = [ "--all" ];

  meta = with lib; {
    description = "Low level tooling for WebAssembly in Rust";
    homepage = "https://github.com/bytecodealliance/wasm-tools";
    license = licenses.asl20;
    maintainers = with maintainers; [ ereslibre ];
  };
}
