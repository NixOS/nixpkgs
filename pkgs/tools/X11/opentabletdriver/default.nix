{ lib
, buildDotnetModule
, fetchFromGitHub
, fetchurl
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
  version = "0.6.3.0";

  src = fetchFromGitHub {
    owner = "OpenTabletDriver";
    repo = "OpenTabletDriver";
    rev = "v${version}";
    hash = "sha256-v41qYNBgOXcFnDOJpQYitql1IZP3p8b3may5Pr04dbg=";
  };

  debPkg = fetchurl {
    url = "https://github.com/OpenTabletDriver/OpenTabletDriver/releases/download/v${version}/OpenTabletDriver.deb";
    hash = "sha256-zWSJlkn7K/meTycWNTinC0hp0JubF22dJNOJeEIfGtI=";
  };

  dotnetInstallFlags = [ "--framework=net6.0" ];

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

  buildInputs = runtimeDeps;

  doCheck = true;
  testProjectFile = "OpenTabletDriver.Tests/OpenTabletDriver.Tests.csproj";

  disabledTests = [
    # Require networking
    "OpenTabletDriver.Tests.PluginRepositoryTest.ExpandRepositoryTarballFork"
    "OpenTabletDriver.Tests.PluginRepositoryTest.ExpandRepositoryTarball"
    # Require networking & unused in Linux build
    "OpenTabletDriver.Tests.UpdaterTests.UpdaterBase_ProperlyChecks_Version_Async"
    "OpenTabletDriver.Tests.UpdaterTests.Updater_PreventsUpdate_WhenAlreadyUpToDate_Async"
    "OpenTabletDriver.Tests.UpdaterTests.Updater_AllowsReupdate_WhenInstallFailed_Async"
    "OpenTabletDriver.Tests.UpdaterTests.Updater_HasUpdateReturnsFalse_During_UpdateInstall_Async"
    "OpenTabletDriver.Tests.UpdaterTests.Updater_HasUpdateReturnsFalse_After_UpdateInstall_Async"
    "OpenTabletDriver.Tests.UpdaterTests.Updater_Prevents_ConcurrentAndConsecutive_Updates_Async"
    "OpenTabletDriver.Tests.UpdaterTests.Updater_ProperlyBackups_BinAndAppDataDirectory_Async"
    # Intended only to be run in continuous integration, unnecessary for functionality
    "OpenTabletDriver.Tests.ConfigurationTest.Configurations_DeviceIdentifier_IsNotConflicting"
    # Depends on processor load
    "OpenTabletDriver.Tests.TimerTests.TimerAccuracy"
  ];

  postFixup = ''
    # Give a more "*nix" name to the binaries
    mv $out/bin/OpenTabletDriver.Console $out/bin/otd
    mv $out/bin/OpenTabletDriver.Daemon $out/bin/otd-daemon
    mv $out/bin/OpenTabletDriver.UX.Gtk $out/bin/otd-gui

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
      categories = [ "Utility" ];
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
    homepage = "https://github.com/OpenTabletDriver/OpenTabletDriver";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ thiagokokada ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    mainProgram = "otd";
  };
}
