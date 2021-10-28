{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "tuigreet";
  version = "0.7.0";

  src = fetchFromGitHub {
    owner = "apognu";
    repo = pname;
    rev = version;
    sha256 = "sha256-wiGoaVSTX8+lAc7GCHqN7dsp+uUD755uqMXxxPpbd1k=";
  };

  cargoSha256 = "sha256-63T3ibgRa+/nykqRfzsG4ib1RHa2s2jNHlfZcmaOV7Q=";

  meta = with lib; {
    description = "Graphical console greter for greetd";
    homepage = "https://github.com/apognu/tuigreet";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.linux;
  };
}
