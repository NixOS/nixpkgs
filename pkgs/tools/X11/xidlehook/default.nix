{ lib
, stdenv
, rustPlatform
, fetchFromGitLab
, python3
, xlibsWrapper
, xorg
, libpulseaudio
, pkg-config
, patchelf
, Security
}:

rustPlatform.buildRustPackage rec {
  pname = "xidlehook";
  version = "0.10.0";

  doCheck = false;

  src = fetchFromGitLab {
    owner = "jD91mZM2";
    repo = "xidlehook";
    rev = version;

    sha256 = "1pl7f8fhxfcy0c6c08vkagp0x1ak96vc5wgamigrk1nkd6l371lb";
  };

  cargoBuildFlags = lib.optionals (!stdenv.isLinux) [ "--no-default-features" "--features" "pulse" ];
  cargoSha256 = "1r2xir0x04056kq7j13cpk8984kjrgxbixlacp6vz79yq9c8pv7k";

  buildInputs = [ xlibsWrapper xorg.libXScrnSaver libpulseaudio ] ++ lib.optional stdenv.isDarwin Security;
  nativeBuildInputs = [ pkg-config patchelf python3 ];

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
