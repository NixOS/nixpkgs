{ stdenv
, lib
, fetchFromGitHub
, nix-update-script
, cargo
, meson
, ninja
, rustPlatform
, rustc
, pkg-config
, glib
, libshumate
, gst_all_1
, gtk4
, libadwaita
, llvmPackages
, glibc
, pipewire
, wayland
, wrapGAppsHook4
, desktop-file-utils
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ashpd-demo";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "bilelmoussaoui";
    repo = "ashpd";
    rev = "${finalAttrs.version}-demo";
    hash = "sha256-isc0+Mke6XeCCLiuxnjHqrnlGqYuQnmcU1acM14UOno=";
  };

  cargoDeps = rustPlatform.fetchCargoTarball {
    src = "${finalAttrs.src}/ashpd-demo";
    hash = "sha256-9L/WFL2fLCRahjGCVdgV+3HfDMrntdIWcuuOJbzdPiI=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    cargo
    rustPlatform.cargoSetupHook
    rustc
    wrapGAppsHook4
    rustPlatform.bindgenHook
    desktop-file-utils
    glib # for glib-compile-schemas
  ];

  buildInputs = [
    glib
    gtk4
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    libadwaita
    pipewire
    wayland
    libshumate
  ];

  postPatch = ''
    cd ashpd-demo
  '';

  meta = with lib; {
    description = "Tool for playing with XDG desktop portals";
    homepage = "https://github.com/bilelmoussaoui/ashpd/tree/master/ashpd-demo";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
  };
})
