{ lib, stdenv, rustPlatform, fetchFromGitLab
, xlibsWrapper, xorg, libpulseaudio, pkgconfig, patchelf, Security }:

rustPlatform.buildRustPackage rec {
  name = "xidlehook-${version}";
  version = "0.6.1";

  doCheck = false;

  src = fetchFromGitLab {
    owner = "jD91mZM2";
    repo = "xidlehook";
    rev = version;

    sha256 = "04h6j66wif202x4kssagb66nnrz9m9ccs1d0dfh92955yix1ln23";
  };

  cargoBuildFlags = lib.optionals (!stdenv.isLinux) ["--no-default-features" "--features" "pulse"];
  cargoSha256 = "1pdhbqnkgwp2v5zyin8z8049aq8c3kfk04v9wsbz8qla34rgi99s";

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
