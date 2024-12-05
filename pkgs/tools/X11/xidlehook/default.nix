{ lib
, stdenv
, rustPlatform
, fetchFromGitLab
, python3
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

  cargoHash = "sha256-uroO0PgnCkFRNYAZgdTZWgDDbBqq1ZM+dni/A2Qw9fg=";

  buildInputs = [ xorg.libX11 xorg.libXScrnSaver libpulseaudio ] ++ lib.optional stdenv.hostPlatform.isDarwin Security;
  nativeBuildInputs = [ pkg-config patchelf python3 ];

  buildNoDefaultFeatures = !stdenv.hostPlatform.isLinux;
  buildFeatures = lib.optional (!stdenv.hostPlatform.isLinux) "pulse";

  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    RPATH="$(patchelf --print-rpath $out/bin/xidlehook)"
    patchelf --set-rpath "$RPATH:${libpulseaudio}/lib" $out/bin/xidlehook
  '';

  meta = with lib; {
    description = "xautolock rewrite in Rust, with a few extra features";
    homepage = "https://github.com/jD91mZM2/xidlehook";
    license = licenses.mit;
    maintainers = [ ];
    platforms = platforms.unix;
    badPlatforms = platforms.darwin;
    mainProgram = "xidlehook";
  };
}
