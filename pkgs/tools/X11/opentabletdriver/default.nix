{ lib
, buildDotnetModule
, fetchFromGitHub
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
, wrapGAppsHook3
, jq
, coreutils
}:

buildDotnetModule rec {
  pname = "OpenTabletDriver";
  version = "0.6.4.0";

  src = fetchFromGitHub {
    owner = "OpenTabletDriver";
    repo = "OpenTabletDriver";
    rev = "v${version}";
    hash = "sha256-zK+feU96JOXjmkTndM9VyUid3z+MZFxJGH+MXaB6kzk=";
  };

  patches = [
    ./remove-git-from-generate-rules.patch
  ];

  dotnetInstallFlags = [ "--framework=net6.0" ];

  projectFile = [ "OpenTabletDriver.Console" "OpenTabletDriver.Daemon" "OpenTabletDriver.UX.Gtk" ];
  nugetDeps = ./deps.nix;

  executables = [ "OpenTabletDriver.Console" "OpenTabletDriver.Daemon" "OpenTabletDriver.UX.Gtk" ];

  nativeBuildInputs = [
    copyDesktopItems
    wrapGAppsHook3
    # Dependency of generate-rules.sh
    jq
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
    # Can't find Configurations directory
    "OpenTabletDriver.Tests.ConfigurationTest.Configurations_Verify_Configs_With_Schema"
  ];

  preBuild = ''
    patchShebangs generate-rules.sh
  '';

  postFixup = ''
    # Give a more "*nix" name to the binaries
    mv $out/bin/OpenTabletDriver.Console $out/bin/otd
    mv $out/bin/OpenTabletDriver.Daemon $out/bin/otd-daemon
    mv $out/bin/OpenTabletDriver.UX.Gtk $out/bin/otd-gui

    install -Dm644 $src/OpenTabletDriver.UX/Assets/otd.png -t $out/share/pixmaps

    mkdir -p $out/lib/udev/rules.d
    ./generate-rules.sh \
      | sed 's@/usr/bin/env rm@${lib.getExe' coreutils "rm"}@' \
      > $out/lib/udev/rules.d/70-opentabletdriver.rules
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
    maintainers = with maintainers; [ gepbird thiagokokada ];
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    mainProgram = "otd";
  };
}
