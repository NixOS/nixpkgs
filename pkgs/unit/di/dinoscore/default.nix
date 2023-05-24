{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, bzip2
, cairo
, gdk-pixbuf
, glib
, gnome
, gtk4
, libadwaita
, openssl
, pango
, poppler
, portmidi
, python3
, python3Packages
, wrapGAppsHook4
, stdenv
, darwin
}:
rustPlatform.buildRustPackage rec {
  pname = "dinoscore";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "DiNoScore";
    repo = "DiNoScore";
    rev = version;
    hash = "sha256-KJSPw2zGW9JQ6vHzpQU/9uxYfaFow12Up8VnU2gPeBE=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "fern-0.6.0" = "sha256-7tyPLPgpNfM4z97vgYlWkNP18BQOoPZqVJbnDhhaR5s=";
      "pipeline-macro-0.6.0" = "sha256-QBwWfynjcMDcfPC3dcWuWmXjPRlKW6Kpq9Q417PTcxI=";
      "xdg-2.2.0" = "sha256-7rLwLwqNI3wpaew/UIwuARfak5dnewgBoDcAXsKivKo=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook4
    python3 # Pyo3 dependency
    glib # Gio resources
    gnome.adwaita-icon-theme # Icons
  ];

  buildInputs = [
    bzip2
    cairo
    gdk-pixbuf
    glib
    gtk4
    libadwaita
    openssl
    pango
    poppler
    portmidi
    python3
    python3Packages.pikepdf
  ] ++ lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.CoreFoundation
    darwin.apple_sdk.frameworks.Security
  ];

  wrapPrefixVariables = [ "PYTHONPATH" ];

  postInstall = ''
    # Rename the binaries (https://github.com/rust-lang/cargo/issues/1706)
    mv $out/bin/viewer $out/bin/dinoscore-viewer
    mv $out/bin/editor $out/bin/dinoscore-editor
    mv $out/bin/cli $out/bin/dinoscore-cli

    # Install icon
    mkdir -p $out/share/icons/hicolor/scalable/apps
    mv ./res/de.piegames.dinoscore.svg $out/share/icons/hicolor/scalable/apps

    # Install .desktop files
    mkdir -p $out/share/applications
    mv ./res/viewer/de.piegames.dinoscore.viewer.desktop $out/share/applications
    mv ./res/editor/de.piegames.dinoscore.editor.desktop $out/share/applications
  '';

  meta = with lib; {
    description = "The open source musician's digital music stand";
    homepage = "https://github.com/DiNoScore/DiNoScore";
    changelog = "https://github.com/DiNoScore/DiNoScore/blob/${src.rev}/CHANGELOG.md";
    license = licenses.eupl12;
    maintainers = with maintainers; [ piegames ];
  };
}
