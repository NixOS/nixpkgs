{ stdenv, lib, fetchFromGitHub, fetchurl, linkFarmFromDrvs, makeWrapper
,  dotnet-sdk_5, dotnetPackages
}:

let
  fetchNuGet = {name, version, sha256}: fetchurl {
    name = "nuget-${name}-${version}.nupkg";
    url = "https://www.nuget.org/api/v2/package/${name}/${version}";
    inherit sha256;
  };
  deps = import ./deps.nix fetchNuGet;
in
stdenv.mkDerivation rec {
  pname = "depotdownloader";
  version = "2.4.1";

  src = fetchFromGitHub {
    owner = "SteamRE";
    repo = "DepotDownloader";
    rev = "DepotDownloader_${version}";
    sha256 = "1ldwda7wyvzqvqv1wshvqvqaimlm0rcdzhy9yn5hvxyswc0jxirr";
  };

  nativeBuildInputs = [ dotnet-sdk_5 dotnetPackages.Nuget makeWrapper ];

  buildPhase = ''
    export DOTNET_CLI_TELEMETRY_OPTOUT=1
    export DOTNET_NOLOGO=1
    export HOME=$TMP/home

    nuget sources Add -Name tmpsrc -Source $TMP/nuget
    nuget init ${linkFarmFromDrvs "deps" deps} $TMP/nuget

    dotnet restore --source $TMP/nuget DepotDownloader/DepotDownloader.csproj
    dotnet publish --no-restore -c Release --output $out
  '';

  installPhase = ''
    makeWrapper ${dotnet-sdk_5}/bin/dotnet $out/bin/$pname \
      --add-flags $out/DepotDownloader.dll
  '';

  meta = with lib; {
    description = "Steam depot downloader utilizing the SteamKit2 library.";
    license = licenses.gpl2Only;
    maintainers = [ maintainers.babbaj ];
    platforms = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" ];
  };
}
