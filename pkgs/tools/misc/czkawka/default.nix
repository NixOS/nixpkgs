{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, glib
, cairo
, pango
, gdk-pixbuf
, atk
, gtk4
, wrapGAppsHook
, gobject-introspection
, xvfb-run
, testers
, czkawka
}:

rustPlatform.buildRustPackage rec {
  pname = "czkawka";
  version = "5.0.1";

  src = fetchFromGitHub {
    owner = "qarmin";
    repo = "czkawka";
    rev = version;
    sha256 = "sha256-ochHohwCOKCF9kiiMxMIaJXaHUWNbq7pIh+VNRKQlcg=";
  };

  cargoSha256 = "sha256-ap8OpaLs1jZtEHbXVZyaGj3gvblWtyHmYrHiHvZKhfs=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook
    gobject-introspection
  ];

  buildInputs = [
    glib
    cairo
    pango
    gdk-pixbuf
    atk
    gtk4
  ];

  checkInputs = [
    xvfb-run
  ];

  checkPhase = ''
    runHook preCheck
    xvfb-run cargo test
    runHook postCheck
  '';

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
