{ config, lib, pkgs, fetchFromGitHub, rustPlatform, pkg-config, lz4
, libxkbcommon }:
rustPlatform.buildRustPackage rec {
  pname = "swww";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "Horus645";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ofJTL+9izMmwENaEVYQ7rjpoEFR1J2szkJxzYb09N7g=";
  };
  cargoSha256 = "sha256-ntulNQUQZ42CGvwnnQSMQsr/MDSNY/5/Aq2Ew9QItn8=";
  buildInputs = [ lz4 libxkbcommon ];
  doCheck = false; # Integration tests do not work in sandbox enviroment
  nativeBuildInputs = [ pkg-config ];
  meta = with lib; {
    description = "Efficient animated wallpaper daemon for wayland, controlled at runtime";
    homepage = "https://github.com/Horus645/swww";
    license = licenses.gpl3;
    maintainers = with maintainers; [ mateodd25 ];
    platforms = platforms.linux;
  };
}
