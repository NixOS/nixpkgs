{ fetchFromGitHub
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

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-SkCEA9CKqzy0wSIUj0DG6asIysD7G9i3nJ9jwhwAUqY=";
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

  postPatch = ''
    substituteInPlace src/utils/memory.rs \
      --replace '"dmidecode"' '"${dmidecode}/bin/dmidecode"'
  '';

  mesonFlags = [ "-Dprofile=default" ];

  meta = with lib; {
    homepage = "https://github.com/nokyan/resources";
    description = "Monitor your system resources and processes";
    license = licenses.gpl3Plus;
    mainProgram = "resources";
    maintainers = with maintainers; [ ewuuwe ];
    platforms = platforms.linux;
  };
}
