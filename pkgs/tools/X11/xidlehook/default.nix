{ lib, stdenv, rustPlatform, fetchFromGitLab, python3
, xlibsWrapper, xorg, libpulseaudio, pkgconfig, patchelf, Security }:

rustPlatform.buildRustPackage rec {
  pname = "xidlehook";
  version = "0.8.0";

  doCheck = false;

  src = fetchFromGitLab {
    owner = "jD91mZM2";
    repo = "xidlehook";
    rev = version;

    sha256 = "127b20y86xs2wq5ka236057nyrh87fgzhjqbl6azf002afnbsn5m";
  };

  cargoBuildFlags = lib.optionals (!stdenv.isLinux) ["--no-default-features" "--features" "pulse"];
  cargoSha256 = "0wakw3pqgwfwarjfb3h0a2javrhnf509v3j547a7p9k5kbjb5np0";

  buildInputs = [ xlibsWrapper xorg.libXScrnSaver libpulseaudio ] ++ lib.optional stdenv.isDarwin Security;
  nativeBuildInputs = [ pkgconfig patchelf python3 ];

  postFixup = lib.optionalString stdenv.isLinux ''
    RPATH="$(patchelf --print-rpath $out/bin/xidlehook)"
    patchelf --set-rpath "$RPATH:${libpulseaudio}/lib" $out/bin/xidlehook
  '';

  meta = with lib; {
    description = "xautolock rewrite in Rust, with a few extra features";
    homepage = https://github.com/jD91mZM2/xidlehook;
    license = licenses.mit;
    maintainers = with maintainers; [ jD91mZM2 ];
    platforms = platforms.unix;
  };
}
