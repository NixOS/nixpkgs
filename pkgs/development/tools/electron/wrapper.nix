{
  stdenv,
  callPackage,
  electron-unwrapped,
  wrapGAppsHook3,
  makeWrapper,
  gsettings-desktop-schemas,
  glib,
  gtk3,
  gtk4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "electron";
  inherit (electron-unwrapped) version;

  nativeBuildInputs = [
    wrapGAppsHook3
    makeWrapper
  ];
  buildInputs = [
    # needed for GSETTINGS_SCHEMAS_PATH
    gsettings-desktop-schemas
    glib
    gtk3
    gtk4
  ];
  dontWrapGApps = true;

  buildCommand = ''
    gappsWrapperArgsHook
    mkdir -p $out/bin
    makeWrapper "${electron-unwrapped}/libexec/electron/electron" "$out/bin/electron" \
      "''${gappsWrapperArgs[@]}" \
      --set CHROME_DEVEL_SANDBOX $out/libexec/electron/chrome-sandbox

    ln -s ${electron-unwrapped}/libexec $out/libexec
  '';

  passthru = {
    unwrapped = electron-unwrapped;
    inherit (electron-unwrapped) headers dist;
  }
  // (callPackage ./hooks { electron = finalAttrs.finalPackage; });

  inherit (electron-unwrapped) meta;
})
