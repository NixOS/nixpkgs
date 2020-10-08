{ lib, stdenv, rustPlatform, fetchFromGitLab, python3
, xlibsWrapper, xorg, libpulseaudio, pkgconfig, patchelf, Security }:

rustPlatform.buildRustPackage rec {
  pname = "xidlehook";
  version = "0.9.1";

  doCheck = false;

  src = fetchFromGitLab {
    owner = "jD91mZM2";
    repo = "xidlehook";
    rev = version;

    sha256 = "00j2iwp25hz9jlr45qszyipljqdnh7h3ni9bkd2lmk58kkvmhf1s";
  };

  cargoBuildFlags = lib.optionals (!stdenv.isLinux) ["--no-default-features" "--features" "pulse"];
  cargoSha256 = "050ihjhg33223x6pgvhqrjprx1clkj2x3jr6acf716vbwm3m0bmz";

  buildInputs = [ xlibsWrapper xorg.libXScrnSaver libpulseaudio ] ++ lib.optional stdenv.isDarwin Security;
  nativeBuildInputs = [ pkgconfig patchelf python3 ];

  postFixup = lib.optionalString stdenv.isLinux ''
    RPATH="$(patchelf --print-rpath $out/bin/xidlehook)"
    patchelf --set-rpath "$RPATH:${libpulseaudio}/lib" $out/bin/xidlehook
  '';

  meta = with lib; {
    description = "xautolock rewrite in Rust, with a few extra features";
    homepage = "https://github.com/jD91mZM2/xidlehook";
    license = licenses.mit;
    maintainers = with maintainers; [ jD91mZM2 ];
    platforms = platforms.unix;
    badPlatforms = platforms.darwin;
  };
}
