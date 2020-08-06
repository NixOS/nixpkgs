{ lib, stdenv, fetchFromGitHub, fetchurl, makeWrapper, makeDesktopItem, linkFarmFromDrvs
, dotnet-sdk, dotnet-netcore, dotnetPackages
, ffmpeg_4, alsaLib, SDL2, lttng-ust, numactl, alsaPlugins
}:

let
  runtimeDeps = [
    ffmpeg_4 alsaLib SDL2 lttng-ust numactl
  ];

  # https://docs.microsoft.com/en-us/dotnet/core/rid-catalog#using-rids
  runtimeId = "linux-x64";

in stdenv.mkDerivation rec {
  pname = "osu-lazer";
  version = "2020.801.0";

  src = fetchFromGitHub {
    owner = "ppy";
    repo = "osu";
    rev = version;
    sha256 = "02klqc56fskc8r8p3z9d38r1i0rwgglfilb97pdqm1ph8jpr1c20";
  };

  nativeBuildInputs = [ dotnet-sdk dotnetPackages.Nuget makeWrapper ];

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
    export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1

    nuget sources Add -Name nixos -Source "$PWD/nixos"
    nuget init "$nugetDeps" "$PWD/nixos"

    # FIXME: https://github.com/NuGet/Home/issues/4413
    mkdir -p $HOME/.nuget/NuGet
    cp $HOME/.config/NuGet/NuGet.Config $HOME/.nuget/NuGet

    dotnet restore --source nixos osu.Desktop

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    dotnet build osu.Desktop \
      --no-restore \
      --configuration Release \
      -p:Version=${version}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    dotnet publish osu.Desktop \
      --no-build \
      --configuration Release \
      --no-self-contained \
      --output $out/lib/osu
    shopt -s extglob
    rm -r $out/lib/osu/runtimes/!(${runtimeId})

    makeWrapper $out/lib/osu/osu\! $out/bin/osu\! \
      --set DOTNET_ROOT "${dotnet-netcore}" \
      --suffix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeDeps}"
    for i in 16 32 48 64 96 128 256 512 1024; do
      install -D ./assets/lazer.png $out/share/icons/hicolor/''${i}x$i/apps/osu\!.png
    done
    cp -r ${makeDesktopItem {
      desktopName = "osu!";
      name = "osu";
      exec = "osu!";
      icon = "osu!";
      comment = meta.description;
      type = "Application";
      categories = "Game;";
    }}/share/applications $out/share

    runHook postInstall
  '';

  # Strip breaks the executable.
  dontStrip = true;

  meta = with lib; {
    description = "Rhythm is just a *click* away";
    homepage = "https://osu.ppy.sh";
    license = with licenses; [ mit cc-by-nc-40 ];
    maintainers = with maintainers; [ oxalica ];
    platforms = [ "x86_64-linux" ];
  };
  passthru.updateScript = ./update.sh;
}
