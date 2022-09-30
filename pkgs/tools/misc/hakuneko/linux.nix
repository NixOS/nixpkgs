{ atomEnv
, autoPatchelfHook
, dpkg
, fetchurl
, makeDesktopItem
, makeWrapper
, udev
, stdenv
, lib
, wrapGAppsHook
, src
, pname
, meta
, version
, desktopName
}:
let
  desktopItem = makeDesktopItem {
    inherit desktopName;
    genericName = "Manga & Anime Downloader";
    categories = [ "Network" "FileTransfer" ];
    exec = pname;
    icon = pname + "-desktop";
    name = pname + "-desktop";
  };
in
stdenv.mkDerivation rec {
  inherit pname version src meta;

  dontBuild = true;
  dontConfigure = true;
  dontPatchELF = true;
  dontWrapGApps = true;

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
    wrapGAppsHook
  ];

  buildInputs = atomEnv.packages;

  unpackPhase = ''
    # The deb file contains a setuid binary, so 'dpkg -x' doesn't work here
    dpkg --fsys-tarfile $src | tar --extract
  '';

  installPhase = ''
    cp -R usr "$out"
    # Overwrite existing .desktop file.
    cp "${desktopItem}/share/applications/${pname}-desktop.desktop" \
       "$out/share/applications/${pname}-desktop.desktop"
  '';

  runtimeDependencies = [
    (lib.getLib udev)
  ];

  postFixup = ''
    makeWrapper $out/lib/${pname}-desktop/${pname} $out/bin/${pname} \
      "''${gappsWrapperArgs[@]}"
  '';

}
