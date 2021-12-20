{ lib
, buildDotnetModule
, fetchFromGitHub
, fetchurl
, dotnetCorePackages
, gtk3
, libX11
, libXrandr
, libappindicator
, libevdev
, libnotify
, udev
, copyDesktopItems
, makeDesktopItem
, nixosTests
, wrapGAppsHook
, dpkg
}:

buildDotnetModule rec {
  pname = "OpenTabletDriver";
  version = "0.5.3.3";

  src = fetchFromGitHub {
    owner = "InfinityGhost";
    repo = "OpenTabletDriver";
    rev = "v${version}";
    sha256 = "k4SoOMKAwHeYSQ80M8Af1DiiDSZIi3gS7lGr2ZrXrEI=";
  };

  debPkg = fetchurl {
    url = "https://github.com/InfinityGhost/OpenTabletDriver/releases/download/v${version}/OpenTabletDriver.deb";
    sha256 = "0v03qiiz28k1yzgxf5qc1mdg2n7kjx6h8vpx9dxz342wwbgqg6ic";
  };

  dotnet-sdk = dotnetCorePackages.sdk_5_0;
  dotnet-runtime = dotnetCorePackages.runtime_5_0;

  dotnetInstallFlags = [ "--framework=net5" ];

  projectFile = [ "OpenTabletDriver.Console" "OpenTabletDriver.Daemon" "OpenTabletDriver.UX.Gtk" ];
  nugetDeps = ./deps.nix;

  executables = [ "OpenTabletDriver.Console" "OpenTabletDriver.Daemon" "OpenTabletDriver.UX.Gtk" ];

  nativeBuildInputs = [
    copyDesktopItems
    wrapGAppsHook
    dpkg
  ];

  runtimeDeps = [
    gtk3
    libX11
    libXrandr
    libappindicator
    libevdev
    libnotify
    udev
  ];

  doCheck = true;
  testProjectFile = "OpenTabletDriver.Tests/OpenTabletDriver.Tests.csproj";

  # Require networking
  disabledTests = [
    "OpenTabletDriver.Tests.PluginRepositoryTest.ExpandRepositoryTarballFork"
    "OpenTabletDriver.Tests.PluginRepositoryTest.ExpandRepositoryTarball"
  ];

  postInstall = ''
    # Give a more "*nix" name to the binaries
    mv $out/bin/OpenTabletDriver.Console $out/bin/otd
    mv $out/bin/OpenTabletDriver.Daemon $out/bin/otd-daemon
    mv $out/bin/OpenTabletDriver.UX.Gtk $out/bin/otd-gui

    cp -r ./OpenTabletDriver/Configurations $out/lib/${pname}
    install -Dm644 $src/OpenTabletDriver.UX/Assets/otd.png -t $out/share/pixmaps

    # TODO: Ideally this should be build from OpenTabletDriver/OpenTabletDriver-udev instead
    dpkg-deb --fsys-tarfile ${debPkg} | tar xf - ./usr/lib/udev/rules.d/99-opentabletdriver.rules
    install -Dm644 ./usr/lib/udev/rules.d/99-opentabletdriver.rules -t $out/lib/udev/rules.d
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
