{ alsaLib
, fetchFromGitHub
, openssl
, pkg-config
, python3
, rustPlatform
, lib, stdenv
, wayland
, xorg
}:

rustPlatform.buildRustPackage rec {
  pname = "ruffle";
  version = "nightly-2020-11-30";

  src = fetchFromGitHub {
    owner = "ruffle-rs";
    repo = pname;
    rev = version;
    sha256 = "0z54swzy47laq3smficd3dyrs2zdi3cj2kb0b4hppjxpkkhiw4x0";
  };

  nativeBuildInputs = [
    pkg-config
    python3
  ];

  buildInputs = [
    alsaLib
    openssl
    wayland
    xorg.libX11
    xorg.libXcursor
    xorg.libXrandr
    xorg.libXi
    xorg.libxcb
    xorg.libXrender
  ];

  cargoSha256 = "05kwfcbzjyyfhiqklhhlv06pinzw9bry4j8l9lk3k04c1q30gzkw";

  meta = with lib; {
    description = "An Adobe Flash Player emulator written in the Rust programming language.";
    homepage = "https://ruffle.rs/";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ govanify ];
    platforms = platforms.linux;
  };
}
