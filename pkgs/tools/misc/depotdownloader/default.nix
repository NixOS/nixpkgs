<<<<<<< HEAD
{ lib
, buildDotnetModule
, fetchFromGitHub
=======
{ stdenv
, lib
, fetchFromGitHub
, buildDotnetModule
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildDotnetModule rec {
  pname = "depotdownloader";
<<<<<<< HEAD
  version = "2.5.0";
=======
  version = "2.4.7";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "SteamRE";
    repo = "DepotDownloader";
    rev = "DepotDownloader_${version}";
<<<<<<< HEAD
    sha256 = "Kgi0u+H5BIAhrjk9e+8H1h0p5Edm3+2twYBPY3JQGps=";
=======
    sha256 = "F67bRIIN9aRbcPVFge3o0I9RF5JqHNDlTPhOpwqdADY=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
