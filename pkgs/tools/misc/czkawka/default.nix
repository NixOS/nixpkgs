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
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "qarmin";
    repo = "czkawka";
    rev = version;
    hash = "sha256-aMQq44vflpsI66CyaXekMfYh/ssH7UkCX0zsO55st3Y=";
  };

  cargoHash = "sha256-1D87O4fje82Oxyj2Q9kAEey4uEzsNT7kTd8IbNT4WXE=";

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
