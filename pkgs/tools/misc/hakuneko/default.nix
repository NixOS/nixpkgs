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
, callPackage
}:
let
  version = "6.1.7";
  pname = "hakuneko";
  desktopName = "HakuNeko Desktop";
  meta = with lib; {
    description = "Manga & Anime Downloader";
    homepage = "https://sourceforge.net/projects/hakuneko/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unlicense;
    maintainers = with maintainers; [
      nloomans
    ];
    platforms = [
      "x86_64-linux"
      "i686-linux"
      "x86_64-darwin"
      # hakuneko has no arm64 macos build yet
    ];
  };
  src = {
    "x86_64-darwin" = fetchurl {
      url = "https://github.com/manga-download/hakuneko/releases/download/v${version}/hakuneko-desktop_${version}_macos_amd64.dmg";
      sha256 = "sha256-XuRVzi+bzr31mBgtzLRtv2ZjfXiSD85iZ7MOfbFw+Yc=";
    };
    "x86_64-linux" = fetchurl {
      url = "https://github.com/manga-download/hakuneko/releases/download/v${version}/hakuneko-desktop_${version}_linux_amd64.deb";
      sha256 = "06bb17d7a06bb0601053eaaf423f9176f06ff3636cc43ffc024438e1962dcd02";
    };
    "i686-linux" = fetchurl {
      url = "https://github.com/manga-download/hakuneko/releases/download/v${version}/hakuneko-desktop_${version}_linux_i386.deb";
      sha256 = "32017d26bafffaaf0a83dd6954d3926557014af4022a972371169c56c0e3d98b";
    };
  }."${stdenv.hostPlatform.system}";

  package =
    if stdenv.isLinux
    then ./linux.nix
    else ./darwin.nix;
in
callPackage package {
    inherit src version meta pname desktopName;
}
