{ lib
, buildDotnetModule
, fetchFromGitHub
}:

buildDotnetModule rec {
  pname = "depotdownloader";
  version = "2.5.0";

  src = fetchFromGitHub {
    owner = "SteamRE";
    repo = "DepotDownloader";
    rev = "DepotDownloader_${version}";
    sha256 = "Kgi0u+H5BIAhrjk9e+8H1h0p5Edm3+2twYBPY3JQGps=";
  };

  projectFile = "DepotDownloader.sln";
  nugetDeps = ./deps.nix;

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
