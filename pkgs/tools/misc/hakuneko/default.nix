{ atomEnv
, autoPatchelfHook
, dpkg
, fetchurl
, makeDesktopItem
, makeWrapper
, udev
, stdenv
, wrapGAppsHook
}:
let
  desktopItem = makeDesktopItem {
    desktopName = "HakuNeko Desktop";
    genericName = "Manga & Anime Downloader";
    categories = "Network;FileTransfer;";
    exec = "hakuneko";
    icon = "hakuneko-desktop";
    name = "hakuneko-desktop";
    type = "Application";
  };
in
stdenv.mkDerivation rec {
  pname = "hakuneko";
  version = "6.1.7";

  src = {
    "x86_64-linux" = fetchurl {
      url = "https://github.com/manga-download/hakuneko/releases/download/v${version}/hakuneko-desktop_${version}_linux_amd64.deb";
      sha256 = "06bb17d7a06bb0601053eaaf423f9176f06ff3636cc43ffc024438e1962dcd02";
    };
    "i686-linux" = fetchurl {
      url = "https://github.com/manga-download/hakuneko/releases/download/v${version}/hakuneko-desktop_${version}_linux_i386.deb";
      sha256 = "32017d26bafffaaf0a83dd6954d3926557014af4022a972371169c56c0e3d98b";
    };
  }."${stdenv.hostPlatform.system}";

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
    cp "${desktopItem}/share/applications/hakuneko-desktop.desktop" \
       "$out/share/applications/hakuneko-desktop.desktop"
  '';

  runtimeDependencies = [
    udev.lib
  ];

  postFixup = ''
    makeWrapper $out/lib/hakuneko-desktop/hakuneko $out/bin/hakuneko \
      "''${gappsWrapperArgs[@]}"
  '';

  meta = with stdenv.lib; {
    description = "Manga & Anime Downloader";
    homepage = "https://sourceforge.net/projects/hakuneko/";
    license = licenses.unlicense;
    maintainers = with maintainers; [
      nloomans
    ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
    ];
  };
}
