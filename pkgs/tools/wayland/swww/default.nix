{ config, lib, pkgs, fetchFromGitHub, rustPlatform, pkg-config, lz4, libxkbcommon }:
rustPlatform.buildRustPackage rec {
  pname = "swww";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "Horus645";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-1SmCeIlcjOX3yCvpfqQ82uq4h2xlGhX9OCwKb6jGK78=";
  };

  cargoSha256 = "sha256-08YM9yTCRJPHdOc1+7F3guYiP3y1WSi3/hzlDRVpitc=";
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
