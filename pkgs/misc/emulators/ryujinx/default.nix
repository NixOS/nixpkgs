{ stdenv, fetchFromGitHub, fetchurl, makeWrapper, makeDesktopItem, linkFarmFromDrvs
, dotnet-sdk_3, dotnetPackages, dotnetCorePackages
, SDL2, libX11, openal
, gtk3, gobject-introspection, wrapGAppsHook
}:

let
  runtimeDeps = [
    SDL2
    gtk3
    libX11
    openal
  ];
in stdenv.mkDerivation rec {
  pname = "ryujinx";
  version = "1.0.5346";

  src = fetchFromGitHub {
    owner = "Ryujinx";
    repo = "Ryujinx";
    rev = "2ce59c44bcb2d789f4d6312b26cf41f36915d73c";
    sha256 = "0hk8jdacg8ryhh0mpnfjbzrrpy8gv87f4hp0hybyypglmaxz8grm";
  };

  nativeBuildInputs = [ dotnet-sdk_3 dotnetPackages.Nuget makeWrapper wrapGAppsHook gobject-introspection ];

  nugetDeps = linkFarmFromDrvs "${pname}-nuget-deps" (import ./deps.nix {
    fetchNuGet = { name, version, sha256 }: fetchurl {
      name = "nuget-${name}-${version}.nupkg";
      url = "https://www.nuget.org/api/v2/package/${name}/${version}";
      inherit sha256;
    };
  });

  patches = [ ./log.patch ]; # Without this, Ryujinx tries to write logs to the nix store. This patch makes it write to "~/.config/Ryujinx/Logs" on Linux.

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

    dotnet restore --source "$PWD/nixos" Ryujinx.sln

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    dotnet build Ryujinx.sln \
      --no-restore \
      --configuration Release \
      -p:Version=${version}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    dotnet publish Ryujinx.sln \
      --no-build \
      --configuration Release \
      --no-self-contained \
      --output $out/lib/ryujinx
    shopt -s extglob

    makeWrapper $out/lib/ryujinx/Ryujinx $out/bin/Ryujinx \
      --set DOTNET_ROOT "${dotnetCorePackages.netcore_3_1}" \
      --suffix LD_LIBRARY_PATH : "${stdenv.lib.makeLibraryPath runtimeDeps}" \
      ''${gappsWrapperArgs[@]}

    for i in 16 32 48 64 96 128 256 512 1024; do
      install -D ${src}/Ryujinx/Ui/assets/Icon.png $out/share/icons/hicolor/''${i}x$i/apps/ryujinx.png
    done
    cp -r ${makeDesktopItem {
      desktopName = "Ryujinx";
      name = "ryujinx";
      exec = "Ryujinx";
      icon = "ryujinx";
      comment = meta.description;
      type = "Application";
      categories = "Game;";
    }}/share/applications $out/share

    runHook postInstall
  '';

  # Strip breaks the executable.
  dontStrip = true;

  meta = with stdenv.lib; {
    description = "Experimental Nintendo Switch Emulator written in C#";
    homepage = "https://ryujinx.org/";
    license = licenses.mit;
    maintainers = [ maintainers.ivar ];
    platforms = [ "x86_64-linux" ];
  };
}
