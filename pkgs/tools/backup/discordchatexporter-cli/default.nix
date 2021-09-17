{ lib, stdenv, fetchFromGitHub, fetchurl, linkFarmFromDrvs, makeWrapper, autoPatchelfHook
, dotnet-sdk_5, dotnetPackages, dotnetCorePackages, cacert
}:

let
  projectFile = "DiscordChatExporter.Cli/DiscordChatExporter.Cli.csproj";
in
stdenv.mkDerivation rec {
  pname = "discordchatexporter-cli";
  version = "2.30.1";

  src = fetchFromGitHub {
    owner = "tyrrrz";
    repo = "discordchatexporter";
    rev = version;
    sha256 = "JSYIhd+DNVOKseHtWNNChECR5hKr+ntu1Yyqtnlg8rM=";
  };

  nativeBuildInputs = [ dotnet-sdk_5 dotnetPackages.Nuget cacert makeWrapper autoPatchelfHook ];
  buildInputs = [ stdenv.cc.cc.lib ];

  nugetDeps = linkFarmFromDrvs "${pname}-nuget-deps" (import ./deps.nix {
    fetchNuGet = { name, version, sha256 }: fetchurl {
      name = "nuget-${name}-${version}.nupkg";
      url = "https://www.nuget.org/api/v2/package/${name}/${version}";
      inherit sha256;
    };
  });

  configurePhase = ''
    runHook preConfigure

    export HOME=$(mktemp -d)
    export DOTNET_CLI_TELEMETRY_OPTOUT=1
    export DOTNET_NOLOGO=1

    nuget sources Add -Name nixos -Source "$PWD/nixos"
    nuget init "$nugetDeps" "$PWD/nixos"

    # FIXME: https://github.com/NuGet/Home/issues/4413
    mkdir -p $HOME/.nuget/NuGet
    cp $HOME/.config/NuGet/NuGet.Config $HOME/.nuget/NuGet

    dotnet restore --source "$PWD/nixos" ${projectFile}

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    dotnet build ${projectFile} \
      --no-restore \
      --configuration Release \
      -p:Version=${version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    dotnet publish ${projectFile} \
      --no-build \
      --configuration Release \
      --no-self-contained \
      --output $out/lib/${pname}
    shopt -s extglob

    makeWrapper $out/lib/${pname}/DiscordChatExporter.Cli $out/bin/discordchatexporter-cli \
      --set DOTNET_ROOT "${dotnetCorePackages.sdk_3_1}"

    runHook postInstall
  '';

  # Strip breaks the executable.
  dontStrip = true;

  meta = with lib; {
    description = "A tool to export Discord chat logs to a file";
    homepage = "https://github.com/Tyrrrz/DiscordChatExporter";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.ivar ];
    platforms = [ "x86_64-linux" ];
  };
  passthru.updateScript = ./updater.sh;
}
