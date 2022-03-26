{ lib
, rustPlatform
, fetchFromSourcehut
}:

rustPlatform.buildRustPackage rec {
  pname = "wlgreet-unstable";
  version = "2022-01-25";

  src = fetchFromSourcehut {
    owner = "~kennylevinsen";
    repo = "wlgreet";
    rev = "8517e578cb64a8fb3bd8f8a438cdbe46f208b87c";
    sha256 = "0la4xlikw61cxvbkil1d22dgvazi7rs17n5i2z02090fvnfxxzxh";
  };

  cargoSha256 = "651d2bf01612534f1c4b0472c812095a86eb064d16879380c87f684c04fe0d8d";

  meta = with lib; {
    description = "Raw wayland greeter for greetd, to be run under sway or similar";
    homepage = "https://git.sr.ht/~kennylevinsen/wlgreet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.linux;
  };
}
