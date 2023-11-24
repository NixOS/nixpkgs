{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, glib
, cairo
, pango
, atk
, gdk-pixbuf
, gtk4
, wrapGAppsHook
}:

rustPlatform.buildRustPackage rec {
  pname = "szyszka";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "qarmin";
    repo = "szyszka";
    rev = version;
    hash = "sha256-LkXGKDFKaY+mg53ZEO4h2br/4eRle/QbSQJTVEMpAoY=";
  };

  cargoHash = "sha256-WJR1BogNnQoZeOt5yBFzjYNZS8OmE84R1FbQpHTb7V0=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    cairo
    pango
    atk
    gdk-pixbuf
    gtk4
  ];

  meta = with lib; {
    description = "A simple but powerful and fast bulk file renamer";
    homepage = "https://github.com/qarmin/szyszka";
    license = licenses.mit;
    maintainers = with maintainers; [ kranzes ];
  };
}
