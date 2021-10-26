{ lib, stdenv, fetchFromGitHub, fetchurl, makeWrapper, makeDesktopItem, linkFarmFromDrvs
, dotnetCorePackages, dotnetPackages, cacert
, ffmpeg_4, alsa-lib, SDL2, lttng-ust, numactl, alsa-plugins
}:

let
  runtimeDeps = [
    ffmpeg_4 alsa-lib SDL2 lttng-ust numactl
  ];

  dotnet-sdk = dotnetCorePackages.sdk_5_0;
  dotnet-runtime = dotnetCorePackages.runtime_5_0;

  # https://docs.microsoft.com/en-us/dotnet/core/rid-catalog#using-rids
  runtimeId = "linux-x64";

in stdenv.mkDerivation rec {
  pname = "osu-lazer";
  version = "2021.1016.0";

  src = fetchFromGitHub {
    owner = "ppy";
    repo = "osu";
    rev = version;
    sha256 = "PaN/+t5qnHaOjh+DfM/Ylw1vESCM3Tejd3li9ml2Z+A=";
  };

  nativeBuildInputs = [
    dotnet-sdk dotnetPackages.Nuget makeWrapper
    # FIXME: Without `cacert`, we will suffer from https://github.com/NuGet/Announcements/issues/49
    cacert
  ];

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

    dotnet restore --source "$PWD/nixos" osu.Desktop --runtime ${runtimeId}

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    dotnet build osu.Desktop \
      --no-restore \
      --configuration Release \
      --runtime ${runtimeId} \
      -p:Version=${version}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    dotnet publish osu.Desktop \
      --no-build \
      --configuration Release \
      --runtime ${runtimeId} \
      --no-self-contained \
      --output $out/lib/osu

    makeWrapper $out/lib/osu/osu\! $out/bin/osu\! \
      --set DOTNET_ROOT "${dotnet-runtime}" \
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

  fixupPhase = ''
    runHook preFixup
    cp -f ${./osu.runtimeconfig.json} "$out/lib/osu/osu!.runtimeconfig.json"
    ln -sft $out/lib/osu ${SDL2}/lib/libSDL2${stdenv.hostPlatform.extensions.sharedLibrary}
    runHook postFixup
  '';

  # Strip breaks the executable.
  dontStrip = true;

  meta = with lib; {
    description = "Rhythm is just a *click* away";
    homepage = "https://osu.ppy.sh";
    license = with licenses; [
      mit
      cc-by-nc-40
      unfreeRedistributable # osu-framework contains libbass.so in repository
    ];
    maintainers = with maintainers; [ oxalica ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "osu!";
  };
  passthru.updateScript = ./update.sh;
}
