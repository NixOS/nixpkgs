{ lib
, rustPlatform
, fetchFromGitHub
, stdenv
, pkg-config
, ffmpeg
}:

rustPlatform.buildRustPackage rec {
  pname = "gifski";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "ImageOptim";
    repo = "gifski";
    rev = version;
    sha256 = "sha256-sPsq/hntNqOdPJcoob1jrDUrLLiBEnfRoDANyFUjOuM=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "ffmpeg-sys-next-6.0.1" = "sha256-/KxW57lt9/qKqNUUZqJucsP0cKvZ1m/FdGCsZxBlxYc=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    ffmpeg
  ];

  buildFeatures = [ "video" ];

  # error: the crate `gifski` is compiled with the panic strategy `abort` which is incompatible with this crate's strategy of `unwind`
  doCheck = !stdenv.isDarwin;

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
  };
}
