{
  lib,
  stdenv,
  electron-unwrapped,
  wrapGAppsHook3,
  makeWrapper,
  gsettings-desktop-schemas,
  glib,
  gtk3,
  gtk4,

  sandboxExecutableName ? "__electron_${lib.versions.major electron-unwrapped.version}-suid-sandbox",
}:

stdenv.mkDerivation {
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
      --run 'export CHROME_DEVEL_SANDBOX="$(
              [ -x /run/wrappers/bin/${sandboxExecutableName} ] \
              && echo /run/wrappers/bin/${sandboxExecutableName} \
              || echo '$out'/libexec/electron/chrome-sandbox)"'

    ln -s ${electron-unwrapped}/libexec $out/libexec
  '';

  passthru = {
    unwrapped = electron-unwrapped;
    inherit (electron-unwrapped) headers dist;
    inherit sandboxExecutableName;
  };

  __structuredAttrs = true;
  strictDeps = true;

  inherit (electron-unwrapped) meta;
}
