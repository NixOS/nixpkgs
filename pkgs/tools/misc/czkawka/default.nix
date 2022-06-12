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
, testers
, czkawka
}:

rustPlatform.buildRustPackage rec {
  pname = "czkawka";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "qarmin";
    repo = "czkawka";
    rev = version;
    sha256 = "sha256-N7fCYcjhYlFVkvWdFpR5cu98Vy+jStlBkR/vz/k1lLY=";
  };

  cargoSha256 = "sha256-4L7OjJ26Qpl5YuHil7JEYU8xWH65jiyFz0a/ufr7wYQ=";

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

  passthru.tests.version = testers.testVersion {
    package = czkawka;
    command = "czkawka_cli --version";
  };

  meta = with lib; {
    description = "A simple, fast and easy to use app to remove unnecessary files from your computer";
    homepage = "https://github.com/qarmin/czkawka";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ yanganto _0x4A6F ];
  };
}
