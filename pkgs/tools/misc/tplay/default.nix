{ lib
, fetchFromGitHub
, rustPlatform
, pkg-config
, opencv
, ffmpeg
, llvmPackages_13
, glibc
}:

let llvmPackages = llvmPackages_13; in
rustPlatform.buildRustPackage rec {
  pname = "tplay";
  version = "0.4.5";

  src = fetchFromGitHub {
    # owner = "maxcurzi";
    owner = "maxcurzi";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-qt5I5rel88NWJZ6dYLCp063PfVmGTzkUUKgF3JkhLQk=";
  };

  cargoHash = "sha256-7gG7V+QNp3YeRoLMSVO7bZL25jNr5EwT4FrvXoT2Gpo=";

  configurePhase = ''
    export LIBCLANG_PATH="${llvmPackages.libclang.lib}/lib";
  '';

  nativeBuildInputs = [
    llvmPackages.clang
    llvmPackages.libclang
    llvmPackages.llvm
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    llvmPackages.libclang
    glibc
    opencv
    ffmpeg
  ];

  meta = with lib; {
    homepage = "https://github.com/maxcurzi/tplay";
    description = "A terminal ASCII media player. View images, gifs, videos, webcam, YouTube, etc.. directly in the terminal as ASCII art.";
    license = licenses.mit;
    platforms = lib.platforms.unix;
  };
}
