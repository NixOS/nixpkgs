{
  lib,
  buildDotnetModule,
  fetchFromGitHub,
  dotnetCorePackages,
}:

buildDotnetModule rec {
  pname = "depotdownloader";
  version = "2.7.4";

  src = fetchFromGitHub {
    owner = "SteamRE";
    repo = "DepotDownloader";
    rev = "DepotDownloader_${version}";
    hash = "sha256-XcUWNr3l1Bsl8SRYm8OS7t2JYppfKJVrVWyM5OILFDA=";
  };

  projectFile = "DepotDownloader.sln";
  nugetDeps = ./deps.json;
  dotnet-sdk = dotnetCorePackages.sdk_9_0;
  dotnet-runtime = dotnetCorePackages.runtime_9_0;

  passthru.updateScript = ./update.sh;

  meta = with lib; {
    description = "Steam depot downloader utilizing the SteamKit2 library";
    changelog = "https://github.com/SteamRE/DepotDownloader/releases/tag/DepotDownloader_${version}";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.babbaj ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "DepotDownloader";
  };
}
