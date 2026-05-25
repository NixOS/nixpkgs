{
  lib,
  mkKdeDerivation,
  runCommandLocal,
  makeWrapper,
  glib,
  gsettings-desktop-schemas,
  replaceVars,
  util-linux,
  pkg-config,
  qtsvg,
  qtwayland,
  breeze,
  SDL2,
  xkeyboard_config,
  xorg-server,
  xf86-input-libinput,
  xf86-input-evdev,
  libxft,
  libxcursor,
  libcanberra,
  libwacom,
  libxkbfile,
  ibus,
}:
let
  # run gsettings with desktop schemas for using in "kcm_access" kcm
  # and in kaccess
  gsettings-wrapper = runCommandLocal "gsettings-wrapper" { nativeBuildInputs = [ makeWrapper ]; } ''
    mkdir -p $out/bin
    makeWrapper ${glib}/bin/gsettings $out/bin/gsettings --prefix XDG_DATA_DIRS : ${gsettings-desktop-schemas.out}/share/gsettings-schemas/${gsettings-desktop-schemas.name}
  '';
in
mkKdeDerivation {
  pname = "plasma-desktop";

  patches = [
    (replaceVars ./hwclock-path.patch {
      hwclock = "${lib.getBin util-linux}/bin/hwclock";
    })
    (replaceVars ./kcm-access.patch {
      gsettings = "${gsettings-wrapper}/bin/gsettings";
    })
    ./tzdir.patch
    ./no-discover-shortcut.patch
    (replaceVars ./wallpaper-paths.patch {
      wallpapers = "${lib.getBin breeze}/share/wallpapers";
    })
  ];

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtsvg
    qtwayland

    SDL2
    libcanberra
    libwacom
    libxkbfile
    xkeyboard_config

    libxcursor
    libxft
    xf86-input-libinput
    xf86-input-evdev
    xorg-server

    ibus
  ];

  # wrap kaccess with wrapped gsettings so it can access accessibility schemas
  qtWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ gsettings-wrapper ]}" ];
}
