{ lib, fetchFromGitHub, rustPlatform, pkg-config, lz4, libxkbcommon }:
rustPlatform.buildRustPackage rec {
  pname = "swww";
  version = "0.8.1";

  src = fetchFromGitHub {
    owner = "Horus645";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-9c/qBmk//NpfvPYjK2QscubFneiQYBU/7PLtTvVRmTA=";
  };

  cargoSha256 = "sha256-AE9bQtW5r1cjIsXA7YEP8TR94wBjaM7emOroVFq9ldE=";
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
