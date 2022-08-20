{ stdenv
, lib
, fetchFromGitHub
, buildDotnetModule
}:

buildDotnetModule rec {
  pname = "depotdownloader";
  version = "2.4.5";

  src = fetchFromGitHub {
    owner = "SteamRE";
    repo = "DepotDownloader";
    rev = "DepotDownloader_${version}";
    sha256 = "0i5qgjnliji1g408ks1034r69vqdmfnzanb0qm7jmyzwww7vwpnh";
  };

  projectFile = "DepotDownloader.sln";
  nugetDeps = ./deps.nix;

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Steam depot downloader utilizing the SteamKit2 library";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.babbaj ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
  };
}
