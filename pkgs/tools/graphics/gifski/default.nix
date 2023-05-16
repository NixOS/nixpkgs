{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, pkg-config
<<<<<<< HEAD
, ffmpeg
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

rustPlatform.buildRustPackage rec {
  pname = "gifski";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = "gifski";
    rev = version;
<<<<<<< HEAD
    hash = "sha256-sPsq/hntNqOdPJcoob1jrDUrLLiBEnfRoDANyFUjOuM=";
=======
    sha256 = "sha256-sPsq/hntNqOdPJcoob1jrDUrLLiBEnfRoDANyFUjOuM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ffmpeg-sys-next-6.0.1" = "sha256-/KxW57lt9/qKqNUUZqJucsP0cKvZ1m/FdGCsZxBlxYc=";
    };
  };

<<<<<<< HEAD
  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    ffmpeg
  ];

  buildFeatures = [ "video" ];

  # When the default checkType of release is used, we get the following error:
  #
  #   error: the crate `gifski` is compiled with the panic strategy `abort` which
  #   is incompatible with this crate's strategy of `unwind`
  #
  # It looks like https://github.com/rust-lang/cargo/issues/6313, which does not
  # outline a solution.
  #
  checkType = "debug";
=======
  nativeBuildInputs = lib.optionals stdenv.isLinux [ pkg-config ];

  # error: the crate `gifski` is compiled with the panic strategy `abort` which is incompatible with this crate's strategy of `unwind`
  doCheck = !stdenv.isDarwin;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # error: linker `/usr/bin/x86_64-linux-gnu-gcc` not found
  postPatch = ''
    rm .cargo/config.toml;
  '';

  meta = with lib; {
    description = "GIF encoder based on libimagequant (pngquant)";
    homepage = "https://gif.ski/";
    changelog = "https://github.com/ImageOptim/gifski/releases/tag/${src.rev}";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ figsoda marsam ];
<<<<<<< HEAD
    mainProgram = "gifski";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
