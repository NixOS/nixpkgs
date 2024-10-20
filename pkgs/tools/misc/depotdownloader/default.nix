{ lib
, buildDotnetModule
, fetchFromGitHub
, dotnetCorePackages
}:

buildDotnetModule rec {
  pname = "depotdownloader";
  version = "2.7.2";

  src = fetchFromGitHub {
    owner = "SteamRE";
    repo = "DepotDownloader";
    rev = "DepotDownloader_${version}";
    sha256 = "c8hgeFTgOjRTjaOSrUazko74GdTW5p9i7+YJIqR28hw=";
  };

  projectFile = "DepotDownloader.sln";
  nugetDeps = ./deps.nix;
  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Steam depot downloader utilizing the SteamKit2 library";
    changelog = "https://github.com/SteamRE/DepotDownloader/releases/tag/DepotDownloader_${version}";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.babbaj ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    mainProgram = "DepotDownloader";
  };
}
