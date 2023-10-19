{ stdenv
, lib
, rustPlatform
, cargo
, rustc
, pkg-config
, desktop-file-utils
, appstream-glib
, wrapGAppsHook4
, meson
, ninja
, libadwaita
, gtk4
, tuxedo-rs
}:
let
  src = tuxedo-rs.src;
  sourceRoot = "source/tailor_gui";
  pname = "tailor_gui";
  version = tuxedo-rs.version;
in
stdenv.mkDerivation {

  inherit src sourceRoot pname version;

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src sourceRoot;
    name = "${pname}-${version}";
    hash = "sha256-DUaSLv1V6skWXQ7aqD62uspq+I9KiWmjlwwxykVve5A=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    pkg-config
    desktop-file-utils
    appstream-glib
    wrapGAppsHook4
  ];

  buildInputs = [
    cargo
    rustc
    meson
    ninja
    libadwaita
    gtk4
  ];

  meta = with lib; {
    description = "Rust GUI for interacting with hardware from TUXEDO Computers";
    longDescription = ''
      An alternative to the TUXEDO Control Center (https://www.tuxedocomputers.com/en/TUXEDO-Control-Center.tuxedo),
      written in Rust.
    '';
    homepage = "https://github.com/AaronErhardt/tuxedo-rs";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ mrcjkb ];
    platforms = platforms.linux;
  };
}
