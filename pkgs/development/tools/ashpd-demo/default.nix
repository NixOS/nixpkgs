{ stdenv
, lib
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, python3
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
  version = "0.0.1-alpha";

  src =
    let
      share = fetchFromGitHub {
        owner = "bilelmoussaoui";
        repo = "ashpd";
        rev = version;
        sha256 = "Lf3Wj4VTDyJ5a1bJTEI6R6aaeEHZ+4hO+BsD98sKb/s=";
      };
    in
    "${share}/ashpd-demo";

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-npqC8lu7acAggJyR4iDkcQZYMNNnseV2pB3+j4G/nIk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
    rustPlatform.rust.cargo
    rustPlatform.cargoSetupHook
    rustPlatform.rust.rustc
    wrapGAppsHook4
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

  # libspa-sys requires this for bindgen
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
  # <spa-0.2/spa/utils/defs.h> included by libspa-sys requires <stdbool.h>
  BINDGEN_EXTRA_CLANG_ARGS = "-I${llvmPackages.libclang.lib}/lib/clang/${lib.getVersion llvmPackages.clang}/include -I${glibc.dev}/include";

  postPatch = ''
    patchShebangs build-aux/meson_post_install.py
    # https://github.com/bilelmoussaoui/ashpd/pull/32
    substituteInPlace build-aux/meson_post_install.py \
      --replace "gtk-update-icon-cache" "gtk4-update-icon-cache"
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "Tool for playing with XDG desktop portals";
    homepage = "https://github.com/bilelmoussaoui/ashpd/tree/master/ashpd-demo";
    license = licenses.mit;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
