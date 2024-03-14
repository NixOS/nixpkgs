{ stdenv
, fetchzip
, wrapGAppsHook
, autoPatchelfHook
, patchelfUnstable
, gtk3
, gnome
, alsa-lib
, dbus-glib
, xorg
, curl
, libva
, pciutils
, suffix
, revision
}:
let
  suffix' = if suffix == "linux"
            then "ubuntu-22.04"
            else suffix;
in
stdenv.mkDerivation {
  name = "firefox";
  src = fetchzip {
    url = "https://playwright.azureedge.net/builds/firefox/${revision}/firefox-${suffix'}.zip";
    hash = "sha256-Wka1qwkrX5GDlekm7NfSEepI8zDippZlfI2tkGyWcFs=";
    stripRoot = false;
  };

  nativeBuildInputs = [ wrapGAppsHook autoPatchelfHook patchelfUnstable];
  buildInputs = [
    gtk3
    gnome.adwaita-icon-theme
    alsa-lib
    dbus-glib
    xorg.libXtst
  ];


  # Firefox uses "relrhack" to manually process relocations from a fixed offset
  patchelfFlags = [ "--no-clobber-old-sections" ];
  runtimeDependencies = [
    curl
    libva.out
    pciutils
  ];

  buildPhase = ''
    cp -R . $out
  '';
}
