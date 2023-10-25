{ lib
, fetchFromGitHub
, rustPlatform
, libevdev
}:

rustPlatform.buildRustPackage rec {
  pname = "evsieve";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "KarsMulder";
    repo = "evsieve";
    rev = "v${version}";
    hash = "sha256-R/y3iyKGE4dzAyNnDwrMCr8JFshYJwNcgHQ8UbtuRj8=";
  };

  cargoHash = "sha256-jkm+mAHejCBZFalUbJNaIxtIl2kwnlPR2wsaYlcfSz8=";

  buildInputs = [ libevdev ];

  doCheck = false; # unit tests create uinput devices

  meta = with lib; {
    description = "A utility for mapping events from Linux event devices";
    homepage = "https://github.com/KarsMulder/evsieve";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ tsowell ];
    platforms = platforms.linux;
  };
}
