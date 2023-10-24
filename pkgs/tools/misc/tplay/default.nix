{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, pkg-config
, opencv
, ffmpeg
, llvmPackages_13
, glibc
, openssl
, alsa-lib
, rust-cbindgen
}:

let llvmPackages = llvmPackages_13; in
rustPlatform.buildRustPackage rec {
  pname = "tplay";
  version = "unstable-2023-10-23";

  src = fetchFromGitHub {
    # owner = "maxcurzi";
    owner = "maxcurzi";
    repo = pname;
    # rev = "v${version}";
    rev = "1f07e66e8331cc8abec04b7285d5759ccba8154b";
    hash = "sha256-zGnnLDqP3vqS2KWBNZ1+7YrqKbRHe33c9dCWmFAb68c=";
  };

  cargoHash = "sha256-eVWOLA+5TVZulMs1q9+62EE7IGdWYugolp7QL6Qe03I=";

  configurePhase = ''
    export LIBCLANG_PATH="${llvmPackages.libclang.lib}/lib";
  '';

  nativeBuildInputs = [
    llvmPackages.clang
    llvmPackages.libclang
    llvmPackages.llvm
    pkg-config
    rustPlatform.bindgenHook
    rust-cbindgen
  ];

  buildInputs = [
    alsa-lib
    ffmpeg
    glibc
    llvmPackages.clang
    llvmPackages.libclang
    opencv
    openssl
    stdenv.cc.cc.lib
    stdenv.cc.cc
  ];

  meta = with lib; {
    homepage = "https://github.com/maxcurzi/tplay";
    description = "A terminal ASCII media player. View images, gifs, videos, webcam, YouTube, etc.. directly in the terminal as ASCII art.";
    license = licenses.mit;
    platforms = lib.platforms.unix;
  };
}
