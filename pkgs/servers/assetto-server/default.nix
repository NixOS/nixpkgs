{ fetchFromGitHub
, buildDotnetModule
, lib
, dotnetCorePackages
}:

buildDotnetModule rec {
  pname = "AssettoServer";
  version = "0.0.54";

  src = fetchFromGitHub {
    owner = "compujuckel";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-ax8xBpIEcBCSg9dSI7osC2cZFq+PrIzDUm7UpDVvAPI=";
  };
  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;
  selfContainedBuild = true;

  projectFile = "AssettoServer/AssettoServer.csproj";
  nugetDeps = ./deps.nix;

  meta = with lib; {
    homepage = "https://assettoserver.org/";
    description = "Custom Assetto Corsa server with focus on freeroam";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ amackillop ];
  };
}
