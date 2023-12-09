{ pkgs
, fetchFromGitHub
, stdenv
, lib
, appstream-glib
, cargo
, desktop-file-utils
, meson
, pkg-config
, rustPlatform
, rustc
, glib
, wrapGAppsHook4
, systemd
, polkit
, dmidecode
, gtk4
, libadwaita
, ninja
}:
stdenv.mkDerivation rec {
  pname = "gnome-resources";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "nokyan";
    repo = "resources";
    rev = "v${version}";
    hash = "sha256-OVz1vsmOtH/5sEuyl2BfDqG2/9D1HGtHA0FtPntKQT0=";
  };

  cargoDeps = rustPlatform.importCargoLock {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      "plotters-cairo-0.4.0" = "sha256-m7ZT5F7WxjZSGQwuytqdMWUgYvcK2UCU/ntJGIJE+UA=";
    };
  };

  nativeBuildInputs = [
    pkg-config
    desktop-file-utils
    appstream-glib
    meson
    ninja
    rustc
    cargo
    rustPlatform.cargoSetupHook
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    polkit
    systemd
  ];

  wrapperPath = lib.makeBinPath ([
    dmidecode
  ]);

  postFixup = ''
    # Ensure all dependencies are in PATH
    wrapProgram $out/bin/resources \
      --prefix PATH : "${wrapperPath}"
  '';

  meta = with lib; {
    homepage = "https://github.com/nokyan/resources";
    description = "Monitor your system resources and processes";
    license = licenses.gpl3Plus;
    mainProgram = "resources";
    maintainers = with maintainers; [ ewuuwe ];
    platforms = platforms.linux;
  };
}
