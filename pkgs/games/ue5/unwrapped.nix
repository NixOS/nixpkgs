{ callPackage, stdenv, unzip, fetchurl, requireFile, dotnet-sdk_3, lib, writeScript, dotnetPackages, linkFarmFromDrvs, ... }:


if !lib.versionAtLeast dotnet-sdk_3.version "3.1" then
  throw "Dotnet sdk has to be atleast 3.1 or newer"
else

let
  fhsenv = callPackage ./fhsenv.nix {};

  deps = import ./cdn-deps.nix { inherit fetchurl; };
  linkDeps = writeScript "link-deps.sh" (lib.concatMapStringsSep "\n" (hash:

  let prefix = lib.concatStrings (lib.take 2 (lib.stringToCharacters hash));
  in ''
    mkdir -p .git/ue4-gitdeps/${prefix}
    ln -s ${lib.getAttr hash deps} .git/ue4-gitdeps/${prefix}/${hash}
  '') (lib.attrNames deps));

  clangBundledToolchain = fetchurl {
    url = "http://cdn.unrealengine.com/Toolchain_Linux/native-linux-v19_clang-11.0.1-centos7.tar.gz";
    sha256 = "tlDwsQKpXi8qKQ3Ywe5BKYx1lnzr4Z8kIA6jqEkBRhM=";
  };

  # From buildDotnetModule
  _nugetDeps = linkFarmFromDrvs "ue5-nuget-deps" (import ./nuget-deps.nix {
    fetchNuGet = { name, version, sha256 }: fetchurl {
      name = "nuget-${name}-${version}.nupkg";
      url = "https://www.nuget.org/api/v2/package/${name}/${version}";
      inherit sha256;
    };
  });

in stdenv.mkDerivation rec {
  pname = "ue5-unwrapped";
  version = "5.0.1";

  sourceRoot = "UnrealEngine-${version}-release";

  src = requireFile {
    name = "${sourceRoot}.zip";
    url = "https://github.com/EpicGames/UnrealEngine/releases/tag/${version}-release";
    sha256 = "062y2cgxj4q8h7vw7a4rv314amhibvlkrcjk02bgy7ld7xpnwa8w";
  };

  buildInputs = [ dotnetPackages.Nuget ];

  DOTNET_SKIP_FIRST_TIME_EXPERIENCE = "1";
  DOTNET_CLI_TELEMETRY_OPTOUT = "1";
  DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "1";
  UE_USE_SYSTEM_MONO = "1";
  UE_USE_SYSTEM_DOTNET = "1";

  unpackPhase = ''
    ${unzip}/bin/unzip $src
  '';

  configurePhase = ''
    export HOME=$(mktemp -d)
    export http_proxy="nodownloads"

    nuget sources Add -Name nixos -Source "$HOME/nixos"
    nuget init "${_nugetDeps}" "$HOME/nixos"


    mkdir -p $HOME/.nuget/NuGet

    cp $HOME/.config/NuGet/NuGet.Config $HOME/.nuget/NuGet

    echo "Copy the symlinks for the gitdeps"
    ${linkDeps}
    cp ${./SetupDotnet.sh} Engine/Build/BatchFiles/Linux/SetupDotnet.sh
    mkdir -p .git/ue4-sdks/
    cp ${clangBundledToolchain} .git/ue4-sdks/v19_clang-11.0.1-centos7.tar.gz

  '';

  buildPhase = ''
    echo "Starting UE5 FHS"
    ${fhsenv}/bin/build-ue5
  '';

  installPhase = ''
    mkdir -p $out
    mv * $out/
  '';

  meta = {
    description = "A suite of integrated tools for game developers to design and build games, simulations, and visualizations";
    homepage = "https://www.unrealengine.com/en-US/unreal-engine-5";
    license = lib.licenses.unfree;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.juliosueiras ];
  };
}
