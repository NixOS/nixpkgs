{ stdenv
, lib
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, rustPlatform
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

stdenv.mkDerivation rec {
  pname = "ashpd-demo";
  version = "0.2.2";

  src =
    let
      share = fetchFromGitHub {
        owner = "bilelmoussaoui";
        repo = "ashpd";
        rev = version;
        sha256 = "9O6XqM4oys/hXgztQQ8tTobJV8U52db/VY6FlTMUvGY=";
      };
    in
    "${share}/ashpd-demo";

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-eFq42m16zzrUBbAqv7BsAf4VxyO93WynLjvIzKbZwnQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    rustPlatform.rust.cargo
    rustPlatform.cargoSetupHook
    rustPlatform.rust.rustc
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

  # FIXME: workaround for Pipewire 0.3.64 deprecated API change, remove when fixed upstream
  # https://gitlab.freedesktop.org/pipewire/pipewire-rs/-/issues/55
  NIX_CFLAGS_COMPILE = [ "-DPW_ENABLE_DEPRECATED" ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Tool for playing with XDG desktop portals";
    homepage = "https://github.com/bilelmoussaoui/ashpd/tree/master/ashpd-demo";
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
