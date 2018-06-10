{ lib, stdenv, rustPlatform, fetchFromGitHub, x11, xorg, libpulseaudio, pkgconfig, patchelf }:

rustPlatform.buildRustPackage rec {
  name = "xidlehook-${version}";
  version = "0.4.8";

  doCheck = false;

  src = fetchFromGitHub {
    owner = "jD91mZM2";
    repo = "xidlehook";
    rev = version;

    sha256 = "1125n5szgq7bziz3lkrhb2a2iac93ap63g2xr78ap7b9i3gxs3xh";
  };

  cargoBuildFlags = lib.optionals (!stdenv.isLinux) ["--no-default-features" "--features" "pulse"];
  cargoSha256 = "1mrg59flmmqg5wwi2l8lw6p1xpgdw597fdfsmpn8b126rgzqmjl8";

  buildInputs = [ x11 xorg.libXScrnSaver libpulseaudio ];
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
