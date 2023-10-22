{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, pkg-config
, glib
, cairo
, pango
, gdk-pixbuf
, atk
, gtk4
, Foundation
, wrapGAppsHook4
, gobject-introspection
, xvfb-run
, testers
, czkawka
}:

rustPlatform.buildRustPackage rec {
  pname = "czkawka";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "qarmin";
    repo = "czkawka";
    rev = version;
    hash = "sha256-uKmiBNwuu3Eduf0v3p2VYYNf6mgxJTBUsYs+tKZQZys=";
  };

  cargoHash = "sha256-iBO99kpITVl7ySlXPkEg2YecS1lonVx9CbKt9WI180s=";

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
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    Foundation
  ];

  nativeCheckInputs = [
    xvfb-run
  ];

  checkPhase = ''
    runHook preCheck
    xvfb-run cargo test
    runHook postCheck
  '';

  doCheck = stdenv.hostPlatform.isLinux
          && (stdenv.hostPlatform == stdenv.buildPlatform);

  passthru.tests.version = testers.testVersion {
    package = czkawka;
    command = "czkawka_cli --version";
  };

  postInstall = ''
    # Install Icons
    install -Dm444 -t $out/share/icons/hicolor/scalable/apps data/icons/com.github.qarmin.czkawka.svg
    install -Dm444 -t $out/share/icons/hicolor/scalable/apps data/icons/com.github.qarmin.czkawka-symbolic.svg

    # Install MetaInfo
    install -Dm444 -t $out/share/metainfo data/com.github.qarmin.czkawka.metainfo.xml

    # Install Desktop Entry
    install -Dm444 -t $out/share/applications data/com.github.qarmin.czkawka.desktop
  '';

  meta = with lib; {
    changelog = "https://github.com/qarmin/czkawka/raw/${version}/Changelog.md";
    description = "A simple, fast and easy to use app to remove unnecessary files from your computer";
    homepage = "https://github.com/qarmin/czkawka";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ yanganto _0x4A6F ];
  };
}
