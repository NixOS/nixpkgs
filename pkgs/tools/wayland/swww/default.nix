{ config, lib, pkgs, fetchFromGitHub, rustPlatform, pkg-config, lz4
, libxkbcommon, ... }:

rustPlatform.buildRustPackage rec {
  pname = "swww";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "Horus645";
    repo = pname;
    rev = "d45ab41a0c83b6f49a0279618e91ddfc0853bb6a";
    sha256 = "K9ZH/774BmzjEFj3gxzTALQex0T12B8ZuGEB878Qbc0=";
  };
  cargoSha256 = "sha256-boCXh9QFfxxtqxElrEHtBJMeCQikaUoytIVshwXRA10=";
  buildInputs = [ lz4 libxkbcommon ];
  doCheck = false; # Integration tests do not work in sandbox enviroment
  nativeBuildInputs = [ pkg-config ];
  meta = with lib; {
    description =
      "Efficient animated wallpaper daemon for wayland, controlled at runtime";
    homepage = "https://github.com/Horus645/swww";
    maintainers = with maintainers; [ mateodd25 ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
