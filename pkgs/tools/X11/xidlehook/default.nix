{ lib, stdenv, rustPlatform, fetchFromGitLab, python3
, xlibsWrapper, xorg, libpulseaudio, pkgconfig, patchelf, Security }:

rustPlatform.buildRustPackage rec {
  pname = "xidlehook";
  version = "0.8.2";

  doCheck = false;

  src = fetchFromGitLab {
    owner = "jD91mZM2";
    repo = "xidlehook";
    rev = version;

    sha256 = "1zvr3vk76x0gsq6z5rrnliv2bvshsm8bhkspc41bbj4kniz4h5bw";
  };

  cargoBuildFlags = lib.optionals (!stdenv.isLinux) ["--no-default-features" "--features" "pulse"];
  cargoSha256 = "0dxz5mbdc93xb02vnmd29i2kdh05c7vx9h28x5qgs3jvddyb3xmn";

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
    badPlatforms = platforms.darwin;
  };
}
