{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, glib
, cairo
, pango
, gdk-pixbuf
, atk
, gtk3
}:

rustPlatform.buildRustPackage rec {
  pname = "czkawka";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "qarmin";
    repo = pname;
    rev = version;
    sha256 = "sha256-OBe6nk5C3kO5Lkas9+G+VY3xAzY7SWx8W5CkSbaYJ9Y=";
  };

  cargoSha256 = "sha256-Jghkf1mX5ic7zB2KmtOZbSxgF8C6KjRdGG1Yt+dzylI=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    glib
    cairo
    pango
    gdk-pixbuf
    atk
    gtk3
  ];

  meta = with lib; {
    description = "A simple, fast and easy to use app to remove unnecessary files from your computer";
    homepage = "https://github.com/qarmin/czkawka";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ yanganto ];
  };
}
