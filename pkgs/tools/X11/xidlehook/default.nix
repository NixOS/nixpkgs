{ lib, rustPlatform, fetchFromGitHub, x11, xorg, libpulseaudio, pkgconfig, patchelf
, stdenv}:

rustPlatform.buildRustPackage rec {
  name = "xidlehook-${version}";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "jD91mZM2";
    repo = "xidlehook";
    rev = version;

    sha256 = "0h84ichm1v2wdmm4w1n7jr70yfb9hhi7kykvd99ppg00h1x9lr7w";
  };

  cargoSha256 = "0a1bl6fnfw6xy71q3b5zij52p9skylj1ivqj8my44bfsid2qfn7d";

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
