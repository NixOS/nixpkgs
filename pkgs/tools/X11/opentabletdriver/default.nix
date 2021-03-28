{ stdenv
, lib
, fetchFromGitHub
, fetchurl
, linkFarmFromDrvs
, dotnet-netcore
, dotnet-sdk
, dotnetPackages
, dpkg
, gtk3
, libX11
, libXrandr
, libappindicator
, libevdev
, libnotify
, udev
, copyDesktopItems
, makeDesktopItem
, makeWrapper
, nixosTests
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "OpenTabletDriver";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "InfinityGhost";
    repo = "OpenTabletDriver";
    rev = "v${version}";
    sha256 = "1if2mkj193yzf5si9pwaynrm6wkhqy7ihk4k1lklzcryk5675w36";
  };

  debPkg = fetchurl {
    url = "https://github.com/InfinityGhost/OpenTabletDriver/releases/download/v${version}/OpenTabletDriver.deb";
    sha256 = "16a1rr0yxra1dhwysbbfgsxpigh2jhjlsl7r28dgp8qcxncck7wg";
  };

  nativeBuildInputs = [
    dotnet-sdk
    dotnetPackages.Nuget
    dpkg
    copyDesktopItems
    makeWrapper
    wrapGAppsHook
  ];

  nugetDeps = linkFarmFromDrvs "${pname}-nuget-deps" (import ./deps.nix {
    fetchNuGet = { name, version, sha256 }: fetchurl {
      name = "nuget-${name}-${version}.nupkg";
      url = "https://www.nuget.org/api/v2/package/${name}/${version}";
      inherit sha256;
    };
  });

  runtimeDeps = [
    gtk3
    libX11
    libXrandr
    libappindicator
    libevdev
    libnotify
    udev
  ];

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

    for project in OpenTabletDriver.{Console,Daemon,UX.Gtk}; do
        dotnet restore --source "$PWD/nixos" $project
    done

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    for project in OpenTabletDriver.{Console,Daemon,UX.Gtk}; do
        dotnet build $project \
            --no-restore \
            --configuration Release \
            --framework net5
    done

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    for project in OpenTabletDriver.{Console,Daemon,UX.Gtk}; do
      dotnet publish $project \
          --no-build \
          --no-self-contained \
          --configuration Release \
          --framework net5 \
          --output $out/lib
    done

    # Give a more "*nix" name to the binaries
    makeWrapper $out/lib/OpenTabletDriver.Console $out/bin/otd \
        "''${gappsWrapperArgs[@]}" \
        --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
        --set DOTNET_ROOT "${dotnet-netcore}" \
        --suffix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeDeps}"

    makeWrapper $out/lib/OpenTabletDriver.Daemon $out/bin/otd-daemon \
        "''${gappsWrapperArgs[@]}" \
        --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
        --set DOTNET_ROOT "${dotnet-netcore}" \
        --suffix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeDeps}"

    makeWrapper $out/lib/OpenTabletDriver.UX.Gtk $out/bin/otd-gui \
        "''${gappsWrapperArgs[@]}" \
        --prefix XDG_DATA_DIRS : "${gtk3}/share/gsettings-schemas/${gtk3.name}/" \
        --set DOTNET_ROOT "${dotnet-netcore}" \
        --suffix LD_LIBRARY_PATH : "${lib.makeLibraryPath runtimeDeps}"

    mkdir -p $out/lib/OpenTabletDriver
    cp -rv ./OpenTabletDriver/Configurations $out/lib/OpenTabletDriver
    install -Dm644 $src/OpenTabletDriver.UX/Assets/otd.png -t $out/share/pixmaps

    # TODO: Ideally this should be build from OpenTabletDriver/OpenTabletDriver-udev instead
    dpkg-deb --fsys-tarfile ${debPkg} | tar xf - ./usr/lib/udev/rules.d/99-opentabletdriver.rules
    install -Dm644 ./usr/lib/udev/rules.d/99-opentabletdriver.rules -t $out/lib/udev/rules.d

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      desktopName = "OpenTabletDriver";
      name = "OpenTabletDriver";
      exec = "otd-gui";
      icon = "otd";
      comment = meta.description;
      type = "Application";
      categories = "Utility;";
    })
  ];

  dontWrapGApps = true;
  dontStrip = true;

  passthru = {
    updateScript = ./update.sh;
    tests = {
      otd-runs = nixosTests.opentabletdriver;
    };
  };

  meta = with lib; {
    description = "Open source, cross-platform, user-mode tablet driver";
    homepage = "https://github.com/InfinityGhost/OpenTabletDriver";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ thiagokokada ];
    platforms = platforms.linux;
  };
}
