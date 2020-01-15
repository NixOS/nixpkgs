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
  version = "5.0.8";

  src = {
    "x86_64-linux" = fetchurl {
      url = "https://github.com/manga-download/hakuneko/releases/download/v${version}/hakuneko-desktop_${version}_linux_amd64.deb";
      sha256 = "924df1d7a0ab54b918529165317e4428b423c9045548d1e36bd634914f7957f0";
    };
    "i686-linux" = fetchurl {
      url = "https://github.com/manga-download/hakuneko/releases/download/v${version}/hakuneko-desktop_${version}_linux_i386.deb";
      sha256 = "988d8b0e8447dcd0a8d85927f5877bca9efb8e4b09ed3c80a6788390e54a48d2";
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
