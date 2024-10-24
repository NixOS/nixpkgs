{
  lib,
  mkKdeDerivation,
  runCommandLocal,
  makeWrapper,
  glib,
  gsettings-desktop-schemas,
  substituteAll,
  util-linux,
  pkg-config,
  qtsvg,
  qtwayland,
  breeze,
  kaccounts-integration,
  SDL2,
  xkeyboard_config,
  xorg,
  libcanberra,
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
    (substituteAll {
      src = ./hwclock-path.patch;
      hwclock = "${lib.getBin util-linux}/bin/hwclock";
    })
    (substituteAll {
      src = ./kcm-access.patch;
      gsettings = "${gsettings-wrapper}/bin/gsettings";
    })
    ./tzdir.patch
    ./no-discover-shortcut.patch
    (substituteAll {
      src = ./wallpaper-paths.patch;
      wallpapers = "${lib.getBin breeze}/share/wallpapers";
    })
  ];

  extraNativeBuildInputs = [ pkg-config ];
  extraBuildInputs = [
    qtsvg
    qtwayland

    kaccounts-integration

    SDL2
    libcanberra
    libxkbfile
    xkeyboard_config

    xorg.libXcursor
    xorg.libXft
    xorg.xf86inputlibinput
    xorg.xf86inputevdev
    xorg.xorgserver

    ibus
  ];

  # wrap kaccess with wrapped gsettings so it can access accessibility schemas
  qtWrapperArgs = [ "--prefix PATH : ${lib.makeBinPath [ gsettings-wrapper ]}" ];
}
