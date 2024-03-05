{
  mkKdeDerivation,
  pkg-config,
  wrapGAppsHook,
  sass,
  qtsvg,
  gsettings-desktop-schemas,
}:
mkKdeDerivation {
  pname = "kde-gtk-config";

  # The gtkconfig KDED module will crash the daemon if the GSettings schemas
  # aren't found.
  patches = [./0001-gsettings-schemas-path.patch];
  preConfigure = ''
    NIX_CFLAGS_COMPILE+=" -DGSETTINGS_SCHEMAS_PATH=\"$GSETTINGS_SCHEMAS_PATH\""
  '';

  extraNativeBuildInputs = [pkg-config wrapGAppsHook sass];
  extraBuildInputs = [qtsvg];
  dontWrapGApps = true; # There is nothing to wrap

  extraCmakeFlags = ["-DGLIB_SCHEMAS_DIR=${gsettings-desktop-schemas.out}/"];
}
