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
, wrapGAppsHook4
, gobject-introspection
, xvfb-run
, testers
, czkawka
}:

rustPlatform.buildRustPackage rec {
  pname = "czkawka";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "qarmin";
    repo = "czkawka";
    rev = version;
    hash = "sha256-3nHsdCndZx7TIbRXhuGdQx8fh8Ff7gYBQyNXIkJ2zPc=";
  };

  cargoHash = "sha256-jBl7+ElK+SEe92qygTocd6R1sgdHf+RpTVJZymhf3mQ=";

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
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

  nativeCheckInputs = [
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
    changelog = "https://github.com/qarmin/czkawka/raw/${version}/Changelog.md";
    description = "A simple, fast and easy to use app to remove unnecessary files from your computer";
    homepage = "https://github.com/qarmin/czkawka";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ yanganto _0x4A6F ];
  };
}
