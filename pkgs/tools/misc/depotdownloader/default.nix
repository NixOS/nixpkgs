{ lib
, buildDotnetModule
, fetchFromGitHub
, dotnetCorePackages
}:

buildDotnetModule rec {
  pname = "depotdownloader";
  version = "2.7.3";

  src = fetchFromGitHub {
    owner = "SteamRE";
    repo = "DepotDownloader";
    rev = "DepotDownloader_${version}";
    sha256 = "TKPUE9PzTUoYmhT1O+Qvb0lukPY6fGs70wSiCdEJUMQ=";
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
