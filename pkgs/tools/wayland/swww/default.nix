{ config, lib, pkgs, fetchFromGitHub, rustPlatform, pkg-config, lz4, libxkbcommon }:
rustPlatform.buildRustPackage rec {
  pname = "swww";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "Horus645";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-58zUi6tftTvNoc/R/HO4RDC7n+NODKOrBCHH8QntKSY=";
  };

  cargoSha256 = "sha256-hL5rOf0G+UBO8kyRXA1TqMCta00jGSZtF7n8ibjGi9k=";
  buildInputs = [ lz4 libxkbcommon ];
  doCheck = false; # Integration tests do not work in sandbox environment
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Efficient animated wallpaper daemon for wayland, controlled at runtime";
    homepage = "https://github.com/Horus645/swww";
    license = licenses.gpl3;
    maintainers = with maintainers; [ mateodd25 ];
    platforms = platforms.linux;
  };
}
