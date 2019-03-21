{ lib, stdenv, rustPlatform, fetchFromGitLab
, xlibsWrapper, xorg, libpulseaudio, pkgconfig, patchelf, Security }:

rustPlatform.buildRustPackage rec {
  name = "xidlehook-${version}";
  version = "0.6.2";

  doCheck = false;

  src = fetchFromGitLab {
    owner = "jD91mZM2";
    repo = "xidlehook";
    rev = version;

    sha256 = "1ca29rw1w2ldahp9f1v9kfrjycbjwx3mab3m25lr82084kaa6lsh";
  };

  cargoBuildFlags = lib.optionals (!stdenv.isLinux) ["--no-default-features" "--features" "pulse"];
  cargoSha256 = "1sy7q875gg6as98lp6m15x9b3lhdikm9326lmqcs5fv3hhzvdlvy";

  buildInputs = [ xlibsWrapper xorg.libXScrnSaver libpulseaudio ] ++ lib.optional stdenv.isDarwin Security;
  nativeBuildInputs = [ pkgconfig patchelf ];

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
