{ stdenv
, lib
, fetchFromGitHub
, buildDotnetModule
}:

buildDotnetModule rec {
  pname = "depotdownloader";
  version = "2.4.7";

  src = fetchFromGitHub {
    owner = "SteamRE";
    repo = "DepotDownloader";
    rev = "DepotDownloader_${version}";
    sha256 = "F67bRIIN9aRbcPVFge3o0I9RF5JqHNDlTPhOpwqdADY=";
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
