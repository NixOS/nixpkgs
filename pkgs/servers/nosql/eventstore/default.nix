{ lib, stdenv
, fetchFromGitHub
, fetchurl
, makeWrapper
, dotnetCorePackages
, mono
, Nuget
}:

let

  dotnet-sdk = dotnetCorePackages.sdk_5_0;

  deps = import ./deps.nix { inherit fetchurl; };

in

stdenv.mkDerivation rec {

  pname = "EventStore";
  version = "5.0.8";

  src = fetchFromGitHub {
    owner = "EventStore";
    repo = "EventStore";
    rev = "oss-v${version}";
    sha256 = "021m610gzmrp2drywl1q3y6xxpy4qayn580d855ag952z9s6w9nj";
  };

  buildInputs = [
    makeWrapper
    dotnet-sdk
    mono
    Nuget
  ];

  # that dependency seems to not be required for building, but pulls in libcurl which fails to be located.
  # see: https://github.com/EventStore/EventStore/issues/1897
  patchPhase = ''
    for f in $(find . -iname "*.csproj"); do
      sed -i '/Include="Microsoft.SourceLink.GitHub"/d' $f
    done
  '';

  buildPhase = ''
    export FrameworkPathOverride=${mono}/lib/mono/4.7.1-api

    # disable default-source so nuget does not try to download from online-repo
    nuget sources Disable -Name "nuget.org"
    # add all dependencies to a source called 'nixos'
    for package in ${toString deps}; do
      nuget add $package -Source nixos
    done

    dotnet restore --source nixos src/EventStore.sln
    dotnet build --no-restore -c Release src/EventStore.sln
  '';

  installPhase = ''
    mkdir -p $out/{bin,lib/eventstore}
    cp -r bin/Release/* $out/lib/eventstore
    makeWrapper "${mono}/bin/mono" $out/bin/eventstored \
      --add-flags "$out/lib/eventstore/EventStore.ClusterNode/net471/EventStore.ClusterNode.exe"
  '';

  doCheck = true;

  checkPhase = ''
    dotnet test src/EventStore.Projections.Core.Tests/EventStore.Projections.Core.Tests.csproj -- RunConfiguration.TargetPlatform=x64
  '';

  meta = {
    homepage = "https://geteventstore.com/";
    description = "Event sourcing database with processing logic in JavaScript";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ puffnfresh ];
    platforms = [ "x86_64-linux" "x86_64-darwin" ];
  };

}
